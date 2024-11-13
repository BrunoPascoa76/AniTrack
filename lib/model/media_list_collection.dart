class MediaListCollection {
  int userId;
  String mediaType;
  List<MediaList> list;

  MediaListCollection({required this.userId,required this.mediaType,this.list=const []});

  factory MediaListCollection.fromJson(Map<String,dynamic> json){
    return MediaListCollection(
      userId:json["userId"] as int,
      mediaType: json["mediaType"] as String,
      list:(json["list"] as List?)?.map((mediaList)=>MediaList.fromJson(mediaList)).toList()??[]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "userId":userId,
      "mediaType":mediaType,
      "list":list.map((mediaList)=>mediaList.toJson()).toList()
    };
  }
}

class MediaList{
  String name;
  List<int> media;

  MediaList({required this.name,this.media=const []});

  factory MediaList.fromJson(Map<String,dynamic> json){
    return MediaList(
      name:json["name"],
      media:(json["entries"] as List?)?.map((media)=>media["mediaId"] as int).toList()??[]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "media":media.map((mediaId)=>{"mediaId":mediaId}).toList()
    };
  }
}