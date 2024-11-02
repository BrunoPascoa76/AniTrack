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
}