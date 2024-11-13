class AiringSchedule {
  int mediaId;
  int episode;
  int airingAt;

  AiringSchedule({
    required this.mediaId,
    required this.episode,
    required this.airingAt
  });

  factory AiringSchedule.fromJson(Map<String, dynamic> json) {
    return AiringSchedule(
      mediaId: json["mediaId"],
      episode: json["episode"],
      airingAt: json["airingAt"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mediaId":mediaId,
      "episode":episode,
      "airingAt":airingAt
    };
  }
}