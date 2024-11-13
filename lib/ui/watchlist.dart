import 'dart:math';

import 'package:anitrack/model/user.dart';
import 'package:anitrack/ui/anime_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:text_scroll/text_scroll.dart';

class Watchlist extends StatelessWidget {
  final String status;

  const Watchlist({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    final ScrollController scrollController = ScrollController();

    return SafeArea(
      child: BlocBuilder<UserBloc,User?>(
        builder: (context,state) {
          if(state==null){
            return const Center(child: CircularProgressIndicator());
          }
          return Query(
            options: QueryOptions(
              document: gql(_getQueryString()),
              variables: {
                "userId": state.id,
                "status": status,
                "type":"ANIME"
              },
              pollInterval: const Duration(seconds: 30)
            ),
            builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }){
              if(result.hasException){
                return Scaffold(body: Text(result.exception.toString()));
              }
              if(result.isLoading){
                return const Center(child: CircularProgressIndicator());
              }
          
              var items=result.data!["MediaListCollection"]["lists"][0]["entries"];
              items.sort((a,b){
                return (-_getRemainingNumberOfEpisodes(a)).compareTo(-_getRemainingNumberOfEpisodes(b));
              });
          
              return RefreshIndicator(
                onRefresh: ()async {refetch!(); return Future.value();},
                child: Padding(
                  padding: const EdgeInsets.only(top:10,left:10,right: 10),
                  child: Scrollbar(
                    interactive: true,
                    controller: scrollController,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _generateWatchListCard(items[index],theme,context);
                      }
                    ),
                  ),
                ),
              ); 
            }
          );
        }
      ) 
    );
  }

  Widget _generateWatchListCard(Map<String,dynamic> item,ThemeData theme,BuildContext context){
    var media=item["media"];
    int remainingEpisodes=_getRemainingNumberOfEpisodes(item);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => AnimeDetailsPage(id: media["id"]))),
        child: Stack(children: [
          SizedBox.expand(child: Image.network(media["coverImage"]["large"],fit:BoxFit.cover)),
        
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
                stops: const [0.8, 0.9, 1.0], // Adjust these values to control the gradient
              ),
            ),
          ),
        
          Column(
            children: [
              if(remainingEpisodes>0)
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _generateBadge(remainingEpisodes,theme)
                  )
                ),
              
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    media["title"]["english"]??media["title"]["native"]??"",
                    style:const TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                  )
                ),
              )
          ])
        ]),
      ),
    );
  }

  Widget _generateBadge(int remainingEpisodes,ThemeData theme){
    return Padding(
      padding: const EdgeInsets.only(top:5,right:5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("$remainingEpisodes",style: const TextStyle(color: Colors.white)),
        )
      ),
    );
  }

  int _getRemainingNumberOfEpisodes(Map<String,dynamic> item){
    int result;
    switch (item["media"]["status"]){
      case "RELEASING":
        result=(item["media"]["nextAiringEpisode"]?["episode"]??1)-1-item["progress"];
      case "FINISHED":
        result=item["media"]["episodes"]-item["progress"];
      case "NOT_YET_RELEASED":
        result=0;
      default:
        result=0;
    }
    return max(result, 0);
  }

  String _getQueryString(){
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
}