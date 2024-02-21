part of 'dark_mode_bloc.dart';

@immutable
abstract class DarkModeEvent {
  final bool isDarkMode;

  const DarkModeEvent({required this.isDarkMode});
}

class ChangeDarkModeEvent extends DarkModeEvent {
  const ChangeDarkModeEvent({required super.isDarkMode});
}