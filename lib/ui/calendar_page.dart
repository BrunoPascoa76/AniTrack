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
    return BlocBuilder<CalendarCubit,CalendarDisplay>(
      builder: (context,state) {
        return Query(
          options: QueryOptions(
            document: gql(_getQueryString()),
            variables: {
              "airingAtLesser": DateTime.now().add(const Duration(days: 7)).copyWith(hour: 0,minute: 0,second: 0,millisecond: 0).millisecondsSinceEpoch~/1000,
              "airingAtGreater": DateTime.now().copyWith(hour: 0,minute: 0,second: 0,millisecond: 0).millisecondsSinceEpoch~/1000
            }
          ),
          builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }){
            if(result.hasException){
              return Scaffold(body:Text(result.exception.toString()));
            }
            if(result.isLoading){
              return const Center(child: CircularProgressIndicator());
            }
            var airingSchedules=result.data!["Page"]["airingSchedules"];
            
            return DefaultTabController(
              length: 7,
              initialIndex: 0,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Calendar"),
                  bottom:TabBar(
                    isScrollable: true,
                    tabs: _getNext7DaysTabs()
                  )
                ),
                body: TabBarView(
                  children: [
                    for (int i = 0; i < 7; i++)
                      _generateCalendarColumn(context, airingSchedules, DateTime.now().add(Duration(days:i)).weekday)
                ])
              ),
            );
          }
        );  
      }
    );
  } 
}

Widget _generateCalendarColumn(BuildContext context, List airingSchedules, int weekday) {

  List validAiringSchedules = airingSchedules.where((element)=>DateTime.fromMillisecondsSinceEpoch((element["airingAt"] as int)*1000).weekday==weekday).toList();



  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisExtent: 250
    ),
    itemCount: validAiringSchedules.length,
    itemBuilder: (context, index) {
      return _generateScheduleCard(context, validAiringSchedules[index]);
    }
  );
}

Widget _generateScheduleCard(BuildContext context, Map<String, dynamic> schedule) {
  ThemeData theme=Theme.of(context);
  int episode = schedule["episode"] as int;
  String airingAt = DateFormat("h:mm a").format(DateTime.fromMillisecondsSinceEpoch((schedule["airingAt"] as int)*1000));

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 170,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(schedule["media"]["coverImage"]["large"], fit: BoxFit.cover)
            ),
          ),
          Text("Episode $episode airing at $airingAt", style: theme.textTheme.bodyMedium,maxLines: 1),
          Center(child: Text(schedule["media"]["title"]["english"] ?? schedule["media"]["title"]["native"], style: theme.textTheme.bodyLarge, maxLines: 2, overflow: TextOverflow.ellipsis))
        ],
      ),
    ),
  );
}

List<Tab> _getNext7DaysTabs() {
  List<Tab> result = [];
  DateTime now = DateTime.now();
  List<String> days = ["","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  for (int i = 0; i < 7; i++) {
    result.add(Tab(text:days[now.add(Duration(days: i)).weekday]));
  }
  return result;
}

String _getQueryString() {
  return r"""
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
      """;
}
