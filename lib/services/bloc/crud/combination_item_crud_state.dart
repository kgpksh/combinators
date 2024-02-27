part of 'combination_item_crud_bloc.dart';

@immutable
abstract class CombinationItemDbState {
  final bool isLoading;

  const CombinationItemDbState({this.isLoading = false});
}

class CombinationItemDbInitialState extends CombinationItemDbState {
  const CombinationItemDbInitialState({super.isLoading = true});
}

class CollectionGroupLoadedState extends CombinationItemDbState {
  final List<ItemBaseEntity> entities;

  const CollectionGroupLoadedState({required this.entities});
}
