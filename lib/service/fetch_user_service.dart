import 'package:anitrack/main.dart';
import 'package:anitrack/model/user.dart';
import 'package:anitrack/service/anilist_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FetchUserService extends StatelessWidget{
  final Widget child;
  const FetchUserService({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    if(context.read<UserBloc>().state!=null){
      return child;
    }
    
    return FutureBuilder(
      future: getIt<AnilistAuth>().getValidToken(),
      builder: (context,snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        return Query(
          options: QueryOptions(
            document: gql(User.getCurrentUserQuery()),
          ),
          builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }){
            if(result.hasException){
              return Scaffold(body: Text(result.exception.toString(),style: const TextStyle(fontSize: 20)));
            }
        
            if(result.isLoading){
              return const Center(child: CircularProgressIndicator());
            }
            context.read<UserBloc>().add(LoadUserEvent(result.data!["Viewer"]));
            return child;
        
          }
        );
      }
    );
  }
}