import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reorder_item_animation_event.dart';
part 'reorder_item_animation_state.dart';

class ReorderItemAnimationBloc extends Bloc<ReorderItemAnimationEvent, ReorderItemAnimationState> {
  ReorderItemAnimationBloc() : super(ReorderItemAnimationInitial()) {
    on<ReorderEvent>((event, emit) {
      emit(ReorderItemAnimationOccurState());
    });

    on<ReorderEventEnd>((event, emit){
      emit(ReorderItemAnimationEndState());
    });
  }
}
