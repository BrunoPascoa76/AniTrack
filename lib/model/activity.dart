class Activity {
  int userId;
  String type;
  int createdAt;

  Activity({
    required this.userId,
    required this.type,
    required this.createdAt
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case "ANIME_LIST" && "MANGA_LIST":
        return ListActivity.fromJson(json);
      default:
        throw Exception("Invalid Activity Type");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "type": type,
      "createdAt": createdAt,
    };
  }
}

class ListActivity extends Activity {
  int mediaId;

  ListActivity({
    required super.userId,
    required super.type,
    required super.createdAt,
    required this.mediaId,
  });

  factory ListActivity.fromJson(Map<String, dynamic> json) {
    return ListActivity(
      userId: json['userId'] as int,
      type: json['type'] as String,
      createdAt: json['createdAt'] as int,
      mediaId: json['media']['id'] as int
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "mediaId": mediaId,
    };
  }
}