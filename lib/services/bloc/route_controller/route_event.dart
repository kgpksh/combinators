import 'package:flutter/foundation.dart';

@immutable
abstract class RouteEvent {
  const RouteEvent();
}

class RouteHomeEvent extends RouteEvent {
  const RouteHomeEvent();
}