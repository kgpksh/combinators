part of 'combination_result_bloc.dart';

@immutable
abstract class CombinationResultEvent {}

class GetRandomCombinationResultEvent extends CombinationResultEvent{
  final List<DatabaseCategory> categoryList;

  GetRandomCombinationResultEvent({required this.categoryList});
}
