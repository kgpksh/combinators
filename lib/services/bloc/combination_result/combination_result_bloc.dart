import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/services/random_result/random_result.dart';
import 'package:flutter/foundation.dart';

part 'combination_result_event.dart';

part 'combination_result_state.dart';

class CombinationResultBloc
    extends Bloc<CombinationResultEvent, CombinationResultState> {
  CombinationResultBloc() : super(CombinationResultInitial()) {
    RandomResult randomResult = RandomResult();
    on<GetRandomCombinationResultEvent>((event, emit) {
      List<List<String>> result = randomResult.getRandomCombination(categoryList: event.categoryList);
      emit(GetRandomCombinationResultState(result: result));
    }, transformer: droppable(),);
  }
}
