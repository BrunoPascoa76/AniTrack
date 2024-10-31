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

    await storage.write(key: 'anilist_access_token', value: token);
  }
}