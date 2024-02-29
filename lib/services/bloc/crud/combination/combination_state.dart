part of 'combination_bloc.dart';

@immutable
abstract class CombinationState {
  final bool isLoading;

  const CombinationState({this.isLoading = false});
}

class CombinationInitial extends CombinationState {}

class CombinationDbInitialState extends CombinationState {
  const CombinationDbInitialState({super.isLoading = true});
}

class CombinationPageLoadedState extends CombinationState {
  final List<DatabaseCategory> combinationData;

  const CombinationPageLoadedState({required this.combinationData});
}
