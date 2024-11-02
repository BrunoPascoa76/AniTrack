import 'package:anitrack/model/media.dart';

class Staff{
  int id;
  String name;
  String gender;
  String? language;
  List<String> primaryOcupations;

  String? description;
  String siteUrl;
  String? staffImageMedium;
  String? staffImageLarge;

  DateTime? dateOfBirth;
  DateTime? dateOfDeath;
  List<MediaConnection> workedIn;
  List<CharacterConnection> characters;
  List<MediaConnection> produced;
  
  Staff({
    required this.id,
    required this.name,
    required this.gender,
    required this.language,
    this.primaryOcupations=const [],

    this.description,
    required this.siteUrl,
    this.staffImageMedium,
    this.staffImageLarge,

    this.dateOfBirth,
    this.dateOfDeath,
    this.workedIn=const [],
    this.characters=const [],
    this.produced=const []
  });

  factory Staff.fromJson(Map<String,dynamic> json){
    return Staff(
      id:json["id"] as int,
      name:json["name"]["full"] as String,
      gender:json["gender"] as String,
      language:json["languageV2"] as String?,
      primaryOcupations: (json["primaryOccupations"] as List?)?.cast<String>()??[],

      description: json["description"] as String?,
      siteUrl: json["siteUrl"] as String,
      staffImageMedium: json["staffImage"]["medium"] as String?,
      staffImageLarge: json["staffImage"]["large"] as String?,

      dateOfBirth: json["dateOfBirth"] as DateTime?,
      dateOfDeath: json["dateOfDeath"] as DateTime?,
      workedIn: (json["characterMedia"]["edges"] as List?)?.map((media)=>MediaConnection.fromJson(media)).toList()??[],
      characters: (json["characters"]["edges"] as List?)?.map((character)=>CharacterConnection.fromJson(character)).toList()??[],
      produced: (json["staffMedia"]["edges"] as List?)?.map((media)=>MediaConnection.fromJson(media)).toList()??[]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "name":{"full":name},
      "gender":gender,
      "languageV2":language,
      "primaryOccupation":primaryOcupations,

      "description":description,
      "siteUrl":siteUrl,
      "staffImage":{
        "medium":staffImageMedium,
        "large":staffImageLarge
      },

      "dateOfBirt":dateOfBirth,
      "dateOfDeath":dateOfDeath,
      "characterMedia":{"edges":workedIn},
      "characters":{"edges":characters},
      "staffMedia":{"edges":produced}
    };
  }
}