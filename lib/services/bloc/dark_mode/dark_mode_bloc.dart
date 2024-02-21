import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'dark_mode_event.dart';

part 'dark_mode_state.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(const DarkModeInitialState(isDarkMode: false)) {
    on<ChangeDarkModeEvent>((event, emit) {
      emit(ChangedDarkModeState(isDarkMode: event.isDarkMode));
    });
  }
}
