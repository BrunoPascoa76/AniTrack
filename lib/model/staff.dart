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
    this.characters=const []
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
      staffImageLarge: json["staffImage"]["large"] as String?
    );
  }
}