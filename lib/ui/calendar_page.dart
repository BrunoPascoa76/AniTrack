import 'package:anitrack/model/user.dart';
import 'package:anitrack/ui/anime_details_page.dart';
import 'package:anitrack/utils/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarCubit calendarCubit = context.read<CalendarCubit>();
    ThemeData theme = Theme.of(context);

    return BlocBuilder<CalendarCubit, CalendarDisplay>(
        builder: (context, state) {
      return DefaultTabController(
        length: 7,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Calendar"),
                      Row(children: [
                        _generateSelectableBox(theme, calendarCubit,
                            CalendarDisplay.all, state, "All"),
                        _generateSelectableBox(theme, calendarCubit,
                            CalendarDisplay.watching, state, "Watching")
                      ])
                    ]),
                bottom: TabBar(isScrollable: true, tabs: _getNext7DaysTabs())),
            body: TabBarView(children: [
              for (int i = 0; i < 7; i++) _LazyFetchCalendar(state,i)
            ])),
      );
    });
  }
}

class _LazyFetchCalendar extends StatelessWidget {
  const _LazyFetchCalendar(this.display,this.weekday);

  final int weekday;
  final CalendarDisplay display;

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
      if (controller.index == weekday) {
        if (display== CalendarDisplay.all) {
          return _calendarQuery(display,context, []);
        } else {
          return _watchingCalendarQuery(display,context);
        }
      } else {
        return Container();
      }
  }

  Widget _watchingCalendarQuery(CalendarDisplay display, BuildContext context) {
    return BlocBuilder<UserBloc, User?>(builder: (context, state) {
      return Query(
          options: QueryOptions(
              document: gql(_getWatchingQueryString()),
              variables: {
                "userId": state!.id,
                "type": "ANIME",
                "status": "CURRENT"
              }),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Scaffold(body: Text(result.exception.toString()));
            }
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            //return Center(child:Text(result.data!["MediaListCollection"]["lists"][0]["entries"].toString()));
            return _calendarQuery(display,context,
                result.data!["MediaListCollection"]["lists"][0]["entries"]);
          });
    });
  }

  Query<Object?> _calendarQuery(CalendarDisplay display, BuildContext context, List items) {
    return Query(
        options: QueryOptions(
            pollInterval: const Duration(seconds: 30),
            document: gql(_getCalendarQueryString(display)),
            variables: {
              "sort": "TIME",
              "airingAtLesser": DateTime.now()
                      .add(Duration(days: weekday + 1))
                      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
                      .millisecondsSinceEpoch ~/
                  1000,
              "airingAtGreater": DateTime.now()
                      .add(Duration(days: weekday))
                      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
                      .millisecondsSinceEpoch ~/
                  1000,
              "mediaIdIn": items.map((e) => e["media"]["id"]).toList()
            }),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Scaffold(body: Text(result.exception.toString()));
          }
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _generateCalendarColumn(
              context, result.data!["Page"]["airingSchedules"], weekday);
        });
  }
}

Widget _generateCalendarColumn(
    BuildContext context, List airingSchedules, int weekday) {
  if (airingSchedules.isEmpty) {
    return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("(╥﹏╥)", style: TextStyle(fontSize: 50)),
      Text("Nothing airing today", style: TextStyle(fontSize: 20))
    ]));
  }

  return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 250),
      itemCount: airingSchedules.length,
      itemBuilder: (context, index) {
        return _generateScheduleCard(context, airingSchedules[index]);
      });
}

Widget _generateScheduleCard(
    BuildContext context, Map<String, dynamic> schedule) {
  ThemeData theme = Theme.of(context);
  int episode = schedule["episode"] as int;
  String airingAt = DateFormat("hh:mm").format(
      DateTime.fromMillisecondsSinceEpoch(
          (schedule["airingAt"] as int) * 1000));

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimeDetailsPage(
            id: schedule["mediaId"] as int,
          ),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 170,
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(schedule["media"]["coverImage"]["large"],
                    fit: BoxFit.cover)),
          ),
          Text("Episode $episode airing at $airingAt",
              style: theme.textTheme.bodyMedium, maxLines: 1),
          Center(
              child: Text(
                  schedule["media"]["title"]["english"] ??
                      schedule["media"]["title"]["native"],
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center))
        ],
      ),
    ),
  );
}

List<Tab> _getNext7DaysTabs() {
  List<Tab> result = [];
  DateTime now = DateTime.now();
  List<String> days = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  for (int i = 0; i < 7; i++) {
    result.add(Tab(text: days[now.add(Duration(days: i)).weekday]));
  }
  return result;
}

String _getCalendarQueryString(CalendarDisplay display) {
  return display == CalendarDisplay.all
      ? r"""
      query Page($sort: [AiringSort], $airingAtLesser: Int, $airingAtGreater: Int) {
        Page {
          airingSchedules(sort: $sort, airingAt_lesser: $airingAtLesser, airingAt_greater: $airingAtGreater) {
            mediaId
            timeUntilAiring
            airingAt
            episode
            media {
              coverImage {
                medium
                large
              }
              title {
                english
                native
              }
            }
          }
        }
      }
      """
      : r"""
        query Page($sort: [AiringSort], $airingAtLesser: Int, $airingAtGreater: Int, $mediaIdIn: [Int]) {
                Page {
                  airingSchedules(sort: $sort, airingAt_lesser: $airingAtLesser, airingAt_greater: $airingAtGreater, mediaId_in: $mediaIdIn) {
                    mediaId
                    timeUntilAiring
                    airingAt
                    episode
                    media {
                      coverImage {
                        medium
                        large
                      }
                      title {
                        english
                        native
                      }
                    }
                  }
                }
              }
      """;
}

String _getWatchingQueryString() {
  return r"""
    query GetMediaList($userId: Int, $type: MediaType, $status: MediaListStatus) {
      MediaListCollection(userId: $userId, type: $type, status: $status) {
        lists {
          name
          status
          entries {
            media {
              id
              title {
                english
                native
              }
              episodes
              nextAiringEpisode {
                episode
              }
              coverImage {
                large
              }
              status
            }
            progress
          }
        }
      } 
    }
    """;
}

_generateSelectableBox(ThemeData theme, CalendarCubit cubit,
    CalendarDisplay display, CalendarDisplay currentDisplay, String label) {
  BorderRadius? radius;

  if (display == CalendarDisplay.all) {
    radius = const BorderRadius.horizontal(left: Radius.circular(8));
  } else if (display == CalendarDisplay.watching) {
    radius = const BorderRadius.horizontal(right: Radius.circular(8));
  }

  return GestureDetector(
      onTap: () {
        cubit.setThemeMode(display);
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.secondary),
            color: display == currentDisplay
                ? theme.colorScheme.secondaryContainer
                : Colors.transparent,
            borderRadius: radius,
          ),
          width: theme.buttonTheme.minWidth,
          height: theme.buttonTheme.height,
          child: Align(
              alignment: Alignment.center,
              child: display == currentDisplay
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.check,
                          color: theme.colorScheme.onSecondaryContainer),
                      Text(label, style: theme.textTheme.bodyMedium)
                    ])
                  : Text(label, style: theme.textTheme.bodyMedium))));
}
