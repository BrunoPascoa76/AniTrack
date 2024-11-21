import 'package:hydrated_bloc/hydrated_bloc.dart';

enum CalendarDisplay {
  all,
  watching
}

class CalendarCubit extends HydratedCubit<CalendarDisplay> {
  CalendarCubit() : super(CalendarDisplay.all);

  void setThemeMode(CalendarDisplay mode) => emit(mode);

  @override
  CalendarDisplay fromJson(Map<String, dynamic> json) {
    return CalendarDisplay.values[json['mode']];
  }

  @override
  Map<String, dynamic> toJson(CalendarDisplay state) {
    return {'mode': state.index};
  }
}