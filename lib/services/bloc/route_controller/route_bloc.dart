import 'package:bloc/bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_state.dart';

import 'route_event.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(const RouteUninitializedState(isLoading: true)) {
    on<RouteHomeEvent>((event, emit) {
      emit(const RouteHomeViewState(isLoading: false));
    });
  }
}
