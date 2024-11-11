import 'package:anitrack/model/user.dart';
import 'package:anitrack/service/anilist_auth.dart';
import 'package:anitrack/ui/client_setup_page.dart';
import 'package:anitrack/ui/navbar.dart';
import 'package:anitrack/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';


final getIt=GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton(()=>AnilistAuth());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const MainApp());
}

const FlutterSecureStorage storage = FlutterSecureStorage();


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: BlocBuilder<ThemeCubit,ThemeController>(
        builder: (context,themeController) {
          AppTheme theme=themeController.themes[themeController.currentTheme];
          return MaterialApp(
            theme: theme.ligthTheme,
            darkTheme: theme.darkTheme,
            themeMode: themeController.mode,
            home: FutureBuilder(
              future: storage.containsKey(key: "clientId"),
              builder: (context,snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator()
                    )
                  );
                }else if(snapshot.data==true){
                  return const Navbar();
                }else{
                  return const ClientSetupPage();
                }
              }
            )
          );
        }
      ),
    );
  }
}
