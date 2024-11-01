import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

//base class for these themes
abstract class AppTheme{
  ThemeData get ligthTheme;
  ThemeData get darkTheme;
}

class DefaultTheme extends AppTheme{
  @override
  ThemeData get ligthTheme => ThemeData.light();

  @override
  ThemeData get darkTheme => ThemeData.dark();
}


class ThemeController {
  final List<AppTheme> themes=[DefaultTheme()];
  ThemeMode mode;
  int currentTheme;

  ThemeController({this.mode=ThemeMode.system,this.currentTheme=0});
  
  Map<String,dynamic> toJson(){
    return {
      'mode':mode.index,
      "currentTheme":currentTheme
    };
  }

  factory ThemeController.fromJson(Map<String,dynamic> json){
    return ThemeController(
      mode:ThemeMode.values[json["mode"] as int],
      currentTheme: json["currentTheme"] as int
    );
  }

  ThemeController copyWith({
    ThemeMode? mode,
    int? currentTheme
  }){
    return ThemeController(
      mode: mode ?? this.mode,
      currentTheme: currentTheme ?? this.currentTheme
    );
  }
}

class ThemeCubit extends HydratedCubit<ThemeController>{
  ThemeCubit(): super(ThemeController());

  void setThemeMode(ThemeMode mode){
    emit(state.copyWith(mode:mode));
  }

  void setCurrentTheme(int currentTheme){
    emit(state.copyWith(currentTheme: currentTheme));
  }

  @override
  ThemeController? fromJson(Map<String, dynamic> json) {
    return ThemeController.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeController state) {
    return state.toJson();
  }
}