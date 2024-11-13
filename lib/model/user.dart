import 'package:flutter_bloc/flutter_bloc.dart';

class User{
  int id;
  String  name;
  String? avatarLarge;
  String? avatarMedium;
  String? siteUrl;

  User({required this.id,required this.name,required this.avatarLarge,required this.avatarMedium,required this.siteUrl});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      avatarLarge:json["avatar"]?["large"],
      avatarMedium:json["avatar"]?["medium"],
      siteUrl:json["siteUrl"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "name":name,
      "avatar":{
        "large":avatarLarge,
        "medium":avatarMedium
      },
      "siteUrl":siteUrl
    };
  }

  static String getCurrentUserQuery(){
    return """
      query GetCurrentUser {
        Viewer {
          id
          name
          avatar {
            large
            medium
          }
          siteUrl
        }
      }
    """;
  }
}

class UserBloc extends Bloc<UserEvent,User?>{
  UserBloc() : super(null){
    on<LoadUserEvent>((event, emit) async {
      emit(User.fromJson(event.data));
    });
  }

}


class UserEvent{}

class LoadUserEvent extends UserEvent{
  Map<String,dynamic> data;
  LoadUserEvent(this.data);
}