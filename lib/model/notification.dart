import 'dart:collection';

class NotificationQueue{
  int maxSize;
  ListQueue<Notification> queue=ListQueue();

  NotificationQueue({this.maxSize=50});

  void add(Notification notification){
    if(queue.length>=maxSize){
      queue.removeFirst();
    }
    queue.add(notification);
  }

  factory NotificationQueue.fromJson(Map<String,dynamic> json){
    NotificationQueue q=NotificationQueue(
      maxSize: json["maxSize"],
    );
    final notifications=json["items"] as List<dynamic>;
    for (var notification in notifications){
      q.add(Notification.fromJson(notification));
    }
    return q;
  }
}

class Notification {
  String type;
  int createdAt;

  Notification({required this.type,required this.createdAt});

  factory Notification.fromJson(Map<String,dynamic> json){
    switch(json["type"]){
      case "AIRING":
        return AiringNotification.fromJson(json);
      case "RELATED_MEDIA_ADDITION":
        return RelatedMediaAdditionNotification.fromJson(json);
      case "MEDIA_DATA_CHANGE":
        return MediaDataChangeNotification.fromJson(json);
      case "MEDIA_MERGE":
        return MediaMergeNotification.fromJson(json);
      case "MEDIA_DELETION":
        return MediaDeleteNotification.fromJson(json);
      default:
        throw Exception("Unknown notification type: ${json["type"]}");
    }
  }

  Map<String,dynamic> toJson(){
    return {
      "type":type,
      "createdAt":createdAt,
    };
  }
}

class AiringNotification extends Notification{
  int animeId;
  int episode;

  AiringNotification({super.type="AIRING",required super.createdAt,required this.animeId,required this.episode});
  
  factory AiringNotification.fromJson(Map<String,dynamic> json){
    return AiringNotification(
      createdAt: json["createdAt"] as int,
      animeId: json["animeId"] as int,
      episode: json["episode"] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "animeId":animeId,
      "episode":episode
    };
  }
}

class RelatedMediaAdditionNotification extends Notification{
  int mediaId;

  RelatedMediaAdditionNotification({super.type="RELATED_MEDIA_ADDITION",required super.createdAt,required this.mediaId});

  factory RelatedMediaAdditionNotification.fromJson(Map<String,dynamic> json){
    return RelatedMediaAdditionNotification(
      createdAt: json["createdAt"] as int,
      mediaId: json["mediaId"] as int
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      ...super.toJson(),
      "mediaId":mediaId
    };
  }
}

class MediaDataChangeNotification extends Notification{
  
}

class MediaMergeNotification extends Notification{

}

class MediaDeleteNotification extends Notification{

}