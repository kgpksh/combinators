part of 'dark_mode_bloc.dart';

@immutable
abstract class DarkModeState {
  final bool isDarkMode;

  const DarkModeState({required this.isDarkMode});
}

class DarkModeInitialState extends DarkModeState {
  const DarkModeInitialState({required super.isDarkMode});
}

class ChangedDarkModeState extends DarkModeState {
  const ChangedDarkModeState({required super.isDarkMode});
}
