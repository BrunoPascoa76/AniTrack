class Media {
  int id;
  String titleEnglish;
  String titleNative;
  String titleRomaji;
  List<String> synonyms;
  String description;

  DateTime? startDate;
  DateTime? endDate;
  String? season;
  int? seasonYear;
  String type;
  String format;
  String source;
  String status;

  int? episodes;
  int? volumes;
  int? chapters;
  int? duration;

  bool? isAdult;
  List<String> genres;
  int? averageScore;

  //using connections for lazy fetching and avoiding infinite nesting
  List<StaffConnection> staff;
  List<StudioConnection> studios;
  List<CharacterConnection> characters;
  List<MediaConnection> relations;

  String siteUrl;
  String? trailerUrl;
  String? bannerImageUrl;
  String? coverImageMedium;

  Media({
    required this.id,
    required this.titleEnglish,
    required this.titleNative,
    required this.titleRomaji,
    required this.synonyms,
    required this.description,

    this.startDate,
    this.endDate,
    this.season,
    this.seasonYear,
    required this.type,
    required this.format,
    required this.source,
    required this.status,

    this.episodes,
    this.volumes,
    this.chapters,
    this.duration,

    this.isAdult,
    this.genres=const [],
    this.averageScore,

    this.staff=const [],
    this.studios=const [],
    this.characters=const [],
    this.relations=const [],
    
    required this.siteUrl,
    this.trailerUrl,
    this.bannerImageUrl,
    this.coverImageMedium
  });

  factory Media.fromJson(Map<String,dynamic> json){
    return Media(
      id:json["id"] as int,
      titleEnglish:json["title"]["english"] as String,
      titleNative:json["title"]["native"] as String,
      titleRomaji:json["title"]["romaji"] as String,
      synonyms:(json["synonyms"] as List).cast<String>(),
      description:json["description"] as String,

      startDate:json["startDate"] as DateTime?,
      endDate:json["endDate"] as DateTime?,
      season:json["season"] as String?,
      seasonYear:json["seasonYear"] as int?,
      type:json["type"] as String,
      format:json["format"] as String,
      source:json["source"] as String,
      status:json["status"] as String,

      episodes:json["episodes"] as int?,
      volumes:json["volumes"] as int?,
      chapters:json["chapters"] as int?,
      duration:json["duration"] as int?,

      isAdult:json["isAdult"] as bool,
      genres:(json["genres"] as List).cast<String>(),
      averageScore:json["averageScore"] as int?,

      staff:(json["staff"]?["edges"] as List?)?.map((item)=>StaffConnection.fromJson(item)).toList()??[],
      studios:(json["studios"]?["edges"] as List?)?.map((item)=>StudioConnection.fromJson(item)).toList()??[],
      characters:(json["characters"]?["edges"] as List?)?.map((item)=>CharacterConnection.fromJson(item)).toList()??[],
      relations: (json["relations"]?["edges"] as List?)?.map((item)=>MediaConnection.fromJson(item)).toList()??[],

      siteUrl:json["siteUrl"] as String,
      trailerUrl:json["trailer"]?["thumbnail"] as String?,
      bannerImageUrl:json["bannerImage"] as String?,
      coverImageMedium:json["coverImage"]?["medium"] as String?
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "title":{
        "english":titleEnglish,
        "native":titleNative,
        "romaji":titleRomaji
      },
      "synonyms":synonyms,
      "description":description,

      "startDate":startDate,
      "endDate":endDate,
      "season":season,
      "seasonYear":seasonYear,
      "type":type,
      "format":format,
      "source":source,
      "status":status,

      "episodes":episodes,
      "volumes":volumes,
      "chapters":chapters,
      "duration":duration,

      "isAdult":isAdult,
      "genres":genres,
      "averageScore":averageScore,

      "staff":{"edges":staff.map((staff)=>staff.toJson()).toList()},
      "studios":{"edges":studios.map((studio)=>studio.toJson()).toList()},
      "characters":{"edges":characters.map((character)=>character.toJson()).toList()},
      "relations":{"edges":relations.map((relation)=>relation.toJson()).toList()},

      "siteUrl":siteUrl,
      "trailer":{"thumbnail":trailerUrl},
      "bannerImage":bannerImageUrl,
      "coverImage":{"medium":coverImageMedium}
    };
  }
}

class MediaConnection{
  int mediaId;
  String? relationType;
  String? characterName;
  String? characterRole;
  String? staffRole;

  MediaConnection({required this.mediaId,this.relationType,this.characterName,this.characterRole,this.staffRole});
  
  factory MediaConnection.fromJson(Map<String,dynamic> json){
    return MediaConnection(
      mediaId: json["node"]["id"] as int,
      relationType: json["relationType"] as String?,
      characterName: json["characterName"] as String?,
      characterRole: json["characterRole"] as String?,
      staffRole: json["staffRole"] as String?
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "node":{"id":mediaId},
      "relationType":relationType,
      "characterName":characterName,
      "characterRole":characterRole,
      "staffRole":staffRole
    };
  }
}

