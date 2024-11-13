import 'package:anitrack/model/media.dart';

class Studio {
  int id;
  String name;
  List<MediaConnection> media;

  Studio({required this.id,required this.name,this.media=const []}); 

  factory Studio.fromJson(Map<String,dynamic> json){
    return Studio(
      id:json["id"],
      name:json["name"],
      media:(json["media"]?["edges"] as List?)?.map((media)=>MediaConnection.fromJson(media)).toList()??[]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "name":name,
      "media":{"edges":media.map((media)=>media.toJson()).toList()}
    };
  }
}

class StudioConnection{
  int studioId;
  bool isMain;

  StudioConnection({required this.studioId,required this.isMain});

  factory StudioConnection.fromJson(Map<String,dynamic> json){
    return StudioConnection(
      studioId: json["node"]["id"] as int,
      isMain: json["isMain"] as bool
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "node":{"id":studioId},
      "isMain":isMain
    };
  }
}