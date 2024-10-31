import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class AnilistAuth{
  String clientId;
  String clientSecret;
  String redirectUri="myapp://auth";
  FlutterSecureStorage storage=const FlutterSecureStorage();

  AnilistAuth(this.clientId,this.clientSecret);

  Future<void> authenticate() async {
    final url=Uri.parse('https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&response_type=token&redirect_uri=$redirectUri');

    final result = await FlutterWebAuth.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'myapp', // Your custom scheme
    );

    final token = Uri.parse(result).fragment.split('&').firstWhere((element) => element.startsWith('access_token=')).split('=')[1];

    await storage.write(key: 'anilistAccessToken', value: token);
    final expirationTime = DateTime.now().add(const Duration(days: 365)).toIso8601String();
    await storage.write(key: 'tokenExpiration', value: expirationTime);
  }
  
  Future<bool> isTokenExpired() async {
    final expirationTimeString=await storage.read(key:"tokenExpiration");

    if(expirationTimeString==null){
      return true;
    }

    final expirationTime=DateTime.parse(expirationTimeString);
    return DateTime.now().isAfter(expirationTime);
  }

  Future<String> getValidToken() async {
    String? anilistAccessToken=await storage.read(key:"anilistAccessToken");
    if (anilistAccessToken==null || await isTokenExpired()){
      await authenticate();
      anilistAccessToken=await storage.read(key:"anilistAccessToken");
    }
    return anilistAccessToken!;
  }
}