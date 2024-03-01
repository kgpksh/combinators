part of 'combination_result_bloc.dart';

@immutable
abstract class CombinationResultState {}

class CombinationResultInitial extends CombinationResultState {}

class GetRandomCombinationResultState extends CombinationResultState{
  final List<List<String>> result;

  GetRandomCombinationResultState({required this.result});
}