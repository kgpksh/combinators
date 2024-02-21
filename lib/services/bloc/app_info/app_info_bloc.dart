import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_info_event.dart';

part 'app_info_state.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  AppInfoBloc()
      : super(const AppInfoInitialState(
            appName: 'Combinators', appVersion: '1.0.0')) {
    on<CallAppInfoEvent>((event, emit) async {
      PackageInfo info = await PackageInfo.fromPlatform();
      emit(CallAppInfoState(
          appName: info.appName, appVersion: info.version));
    });
  }
}
