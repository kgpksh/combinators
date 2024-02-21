import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_view_event.dart';
part 'home_view_state.dart';

class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc() : super(const HomeViewInitial()) {
    on<HomeViewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
