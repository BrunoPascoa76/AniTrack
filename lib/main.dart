import 'package:anitrack/ui/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageControllerCubit>(
          create: (context) => PageControllerCubit()
        )
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Navbar()
      ),
    );
  }
}
