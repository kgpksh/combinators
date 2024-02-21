import 'package:combinators/views/drawers/open_source_license_detail_view.dart';
import 'package:combinators/views/drawers/open_source_license_list_view.dart';
import 'package:combinators/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../oss_licenses.dart';

@immutable
abstract class RouteState {
  final bool isLoading;
  final String loadingText;
  final Widget view;

  const RouteState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
    required this.view,
  });
}

class RouteUninitializedState extends RouteState {
  @override
  final bool isLoading;

  const RouteUninitializedState({required this.isLoading})
      : super(
            isLoading: isLoading,
            view: const Scaffold(
              body: CircularProgressIndicator(),
            ));
}

class RouteHomeViewState extends RouteState {
  @override
  final bool isLoading;

  const RouteHomeViewState({required this.isLoading})
      : super(isLoading: isLoading, view: const HomeView());
}