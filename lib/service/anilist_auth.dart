import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class AnilistAuth{
  String redirectUri="myapp://auth";
  FlutterSecureStorage storage=const FlutterSecureStorage();
  String? anilistAccessToken;

  Future<void> authenticate() async {
    print("starting up");
    String clientId=(await storage.read(key:"clientId"))!;
    //String clientSecret=(await storage.read(key:"clientSecret"))!;
    final url=Uri.https("anilist.co","/api/v2/oauth/authorize",{
      "client_id":clientId,
      "response_type":"token"
    });

    print("auth");
    final result = await FlutterWebAuth.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'myapp', // Your custom scheme
    );
    print("auth return");
    final token = Uri.parse(result).fragment.split('&').firstWhere((element) => element.startsWith('access_token=')).split('=')[1];

    await storage.write(key: 'anilistAccessToken', value: token);
    final expirationTime = DateTime.now().add(const Duration(days: 365)).toIso8601String();
    await storage.write(key: 'tokenExpiration', value: expirationTime);

    anilistAccessToken=token;
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