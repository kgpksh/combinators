part of 'app_info_bloc.dart';

@immutable
abstract class AppInfoState {
  final String appName;
  final String appVersion;

  const AppInfoState({required this.appName, required this.appVersion});
}

class AppInfoInitialState extends AppInfoState {
  const AppInfoInitialState({required super.appName, required super.appVersion});
}

class CallAppInfoState extends AppInfoState {
  const CallAppInfoState({required super.appName, required super.appVersion});
}