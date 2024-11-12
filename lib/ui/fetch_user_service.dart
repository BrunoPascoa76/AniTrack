import 'package:anitrack/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FetchUserService extends StatelessWidget{
  final Widget child;
  const FetchUserService({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(User.getCurrentUserQuery()),
      ),
      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }){
        if(result.hasException){
          return Text(result.exception.toString());
        }

        if(result.isLoading){
          return const Center(child: CircularProgressIndicator());
        }
        context.read<UserBloc>().add(LoadUserEvent(result.data!["Viewer"]));
        return child;

      }
    );
  }
}