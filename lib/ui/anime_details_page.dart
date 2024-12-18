import 'package:anitrack/model/user.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailsPage extends StatefulWidget {
  final int id;

  const AnimeDetailsPage({super.key, required this.id});

  @override
  State<AnimeDetailsPage> createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetailsPage> {
  late ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');

    final AuthLink authLink = AuthLink(getToken: () async {
      const secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(key: "anilistAccessToken");
      return "Bearer $token";
    });

    final link = authLink.concat(httpLink);
    client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(
            store:
                HiveStore(Hive.box<Map<dynamic, dynamic>?>("graphql_cache"))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    ThemeData theme = Theme.of(context);

    return GraphQLProvider(
      client: client,
      child: BlocBuilder<UserBloc, User?>(builder: (context, state) {
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Query(
            options: QueryOptions(
                document: gql(_getQueryString(id)),
                variables: {"mediaId": id, "asHtml": false},
                pollInterval: const Duration(seconds: 30),
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Scaffold(body: Text(result.exception.toString()));
              }
              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              Map<String, dynamic> media = result.data!["Media"];
              return _generateAnimeDetails(media, theme, refetch);
            });
      }),
    );
  }

  Scaffold _generateAnimeDetails(
      Map<String, dynamic> media, ThemeData theme, VoidCallback? refetch) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          refetch!();
          return Future.value();
        },
        child: Align(
            alignment: Alignment.topCenter,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _generateBanner(media, theme)),
                SliverToBoxAdapter(child: _generateTitleCard(theme, media)),
                //TODO: add tabs "Overview" (current), "Relations",...
                SliverToBoxAdapter(
                  child: _generateDescriptionCard(theme, media),
                ),
                //TODO: add genres
                if (media["trailer"] != null)
                  SliverToBoxAdapter(child: _generateTrailerCard(theme, media["trailer"])),
                //TODO: add tags
              ],
            )),
      )),
    );
  }

  Widget _generateTrailerCard(ThemeData theme, Map<String, dynamic> trailer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
            onTap: () => _launchUrl(_generateMediaUrl(trailer)),
            child: Stack(alignment: Alignment.center, children: [
              Image.network(trailer["thumbnail"] ?? "",errorBuilder: (context, error, stackTrace) => Image.network("https://www.thewindowsclub.com/wp-content/uploads/2018/06/Broken-image-icon-in-Chrome.gif",height:100), fit: BoxFit.cover),
              const Icon(Icons.play_circle_fill, size: 64, color: Colors.white)
            ])),
      ),
    );
  }

  String _generateMediaUrl(Map<String, dynamic> trailer) {
    switch (trailer["site"]) {
      case "youtube":
        return 'https://www.youtube.com/watch?v=${trailer['id']}';
      case "dailyMotion":
        return 'https://www.dailymotion.com/video/${trailer['id']}';
      default:
        return "";
    }
  }

  Future<void> _launchUrl(String videoUrl) async {
    if (videoUrl == "") return;
    if (!await launchUrl(Uri.parse(videoUrl))) {
      throw 'Could not launch $videoUrl';
    }
  }

  Widget _generateDescriptionCard(ThemeData theme, Map<String, dynamic> media) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ExpandableNotifier(
            child: ExpandablePanel(
              header: const Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              collapsed: _generateHtmlDescription(media, false),
              expanded: _generateHtmlDescription(media, true),
              theme: ExpandableThemeData(
                  hasIcon: true,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  iconColor: theme.colorScheme.onSurface),
            ),
          )),
    );
  }

  Widget _generateHtmlDescription(Map<String, dynamic> media, bool isExpanded) {
    return Html(
      data: media["description"]??"",
      style: {
        "body": Style(
            fontSize: FontSize(16.0),
            fontWeight: FontWeight.normal,
            margin: Margins.zero,
            maxLines: isExpanded ? null : 3),
        "p": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      },
    );
  }

  Widget _generateTitleCard(ThemeData theme, Map<String, dynamic> media) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(children: [
          media["coverImage"] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(media["coverImage"]["large"],
                      fit: BoxFit.cover))
              : Container(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(media["title"]["english"] ?? media["title"]["native"],
                      style: theme.textTheme.bodyLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  Divider(color: theme.colorScheme.outline),
                  Text("Original Title: ${media['title']['native'] ?? "N/A"}",
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Type: ${_convertFormat(media["format"])}",
                            style: theme.textTheme.bodySmall),
                        Text("Status: ${_convertStatus(media["status"])}",
                            style: theme.textTheme.bodySmall),
                      ]),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                          "Started: ${_convertDate(media["startDate"])}",
                          style: theme.textTheme.bodySmall)),
                  Align(
                      alignment: Alignment.center,
                      child: Text("Ends: ${_convertDate(media["endDate"])}",
                          style: theme.textTheme.bodySmall)),
                ]),
          )
        ]),
      ),
    );
  }

  String _convertStatus(String status) {
    switch (status) {
      case "RELEASING":
        return "Releasing";
      case "FINISHED":
        return "Finished";
      case "NOT_YET_RELEASED":
        return "Not yet released";
      default:
        return "Unknown";
    }
  }

  String _convertDate(Map<String, dynamic> date) {
    if (date["year"] != null && date["month"] != null && date["day"] != null) {
      return "${date["year"]}-${date["month"]}-${date["day"]}";
    } else {
      return "TBA";
    }
  }

  String _convertFormat(String format) {
    switch (format) {
      case "TV":
        return "TV";
      case "TV_SHORT":
        return "Short";
      case "MOVIE":
        return "Movie";
      case "SPECIAL":
        return "Special";
      case "OVA":
        return "OVA";
      case "ONA":
        return "ONA";
      case "MUSIC":
        return "Music";
      case "MANGA":
        return "Manga";
      case "NOVEL":
        return "LN";
      case "ONE_SHOT":
        return "One Shot";
      default:
        return "Unknown";
    }
  }

  Stack _generateBanner(Map<String, dynamic> media, ThemeData theme) {
    return Stack(children: [
      if (media["bannerImage"] != null)
        Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Image.network(media["bannerImage"], fit: BoxFit.cover)),
      Container(
          height: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.5),
            ],
            stops: const [0.50, 0.75, 1.0],
          ))),
      Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: media["bannerImage"] != null
                    ? Colors.white
                    : theme.colorScheme.onSurface,
              )))
    ]);
  }

  String _getQueryString(int id) {
    return r"""
      query Media($mediaId: Int, $asHtml: Boolean) {
        Media(id: $mediaId) {
          title {
            english
            native
          }
          coverImage {
            large
          }
          bannerImage
          relations {
            edges {
              relationType
              node {
                id
                coverImage {
                  medium
                }
                title {
                  english
                  native
                }
                seasonYear
                episodes
                format
              }
            }
          }
          startDate {
            year
            month
            day
          }
          endDate {
            year
            month
            day
          }
          seasonYear
          season
          format
          status
          description(asHtml: $asHtml)
          trailer {
            id
            site
            thumbnail
          }
        }
      }
    """;
  }
}
