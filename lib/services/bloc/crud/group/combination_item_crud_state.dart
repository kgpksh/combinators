part of 'combination_group_bloc.dart';

@immutable
abstract class CombinationGroupDbState {
  final bool isLoading;

  const CombinationGroupDbState({this.isLoading = false});
}

class CombinationItemDbInitialState extends CombinationGroupDbState {
  const CombinationItemDbInitialState({super.isLoading = true});
}

class CollectionGroupLoadedState extends CombinationGroupDbState {
  final List<DatabaseGroup> entities;

  const CollectionGroupLoadedState({required this.entities});
}

class CollectionGroupNameEditedState extends CombinationGroupDbState {
  const CollectionGroupNameEditedState({
    required updatedGroupList,
  });
}