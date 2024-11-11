import 'package:anitrack/model/media.dart';

class Character {
  int id;
  String? gender;
  String name;
  String description;
  String siteUrl;
  List<MediaConnection> appearedIn;
  DateTime? dateOfBirth;
  String? imageMedium;
  String? imageLarge;

  Character({required this.id,this.gender,required this.name,required this.description,required this.siteUrl,this.appearedIn=const [],this.dateOfBirth,this.imageMedium,this.imageLarge});

  factory Character.fromJson(Map<String,dynamic> json){
    return Character(
      id: json["id"] as int,
      gender:json["gender"] as String?,
      name: json["name"]["full"] as String,
      description: json["description"] as String, 
      siteUrl: json["siteUrl"] as String, 
      appearedIn: (json["media"]?["edges"] as List?)?.map((media)=>MediaConnection.fromJson(media)).toList()??[],
      dateOfBirth: json["dateOfBirth"] as DateTime?,
      imageMedium: json["image"]["medium"] as String?,
      imageLarge: json["image"]["large"] as String?
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "name":{"full":name},
      "description":description,
      "siteUrl":siteUrl,
      "media":{"edges":appearedIn.map((media)=>media.toJson()).toList()},
      "dateOfBirth":dateOfBirth,
      "image":{
        "medium":imageMedium,
        "large":imageLarge
      }
    };
  }
}

class CharacterConnection{
  int characterId;
  String? role;
  List<int> voiceActors;

  CharacterConnection({required this.characterId,this.role,this.voiceActors=const []});

  factory CharacterConnection.fromJson(Map<String,dynamic> json){
    return CharacterConnection(
        characterId: json["node"]["id"] as int,
        role: json["role"] as String?,
        voiceActors: (json["voiceActors"] as List?)?.map((actor)=>actor["id"] as int).toList()??[]
      );
  }

  Map<String,dynamic> toJson(){
    return {
      "node":{"id":characterId},
      "role":role,
      "voiceActors":voiceActors.map((actorId)=>{"id":actorId}).toList()
    };
  }
}