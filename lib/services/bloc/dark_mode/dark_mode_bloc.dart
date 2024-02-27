import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'dark_mode_event.dart';

const String isDarkMode = 'isDarkMode';
class DarkModeBloc extends HydratedBloc<DarkModeEvent, bool> {
  DarkModeBloc() :super(false){
    on<ChangeDarkModeEvent>((event, emit) => emit(event.isDarkMode));
  }

  @override
  bool? fromJson(Map<String, dynamic> json) => json[isDarkMode] as bool;

  @override
  Map<String, dynamic>? toJson(bool state) => {isDarkMode : state};
}
