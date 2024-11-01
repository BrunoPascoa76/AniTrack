import 'package:anitrack/service/anilist_auth.dart';
import 'package:anitrack/ui/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';


final getIt=GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton(()=>AnilistAuth());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageCubit>(
          create: (context) => PageCubit()
        )
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Navbar()
      ),
    );
  }
}
