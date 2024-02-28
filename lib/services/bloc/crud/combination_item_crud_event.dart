part of 'combination_item_crud_bloc.dart';

@immutable
abstract class CombinationItemDbEvent {}

class CombinationGroupLoadEvent extends CombinationItemDbEvent {}

class CombinationGroupCreateEvent extends CombinationItemDbEvent {
  final String groupName;

  CombinationGroupCreateEvent({required this.groupName});
}

class CombinationGroupReorderEvent extends CombinationItemDbEvent {
  final String tableName;
  final List<ItemBaseEntity> items;
  final int oldIndex;
  final int newIndex;
  CombinationGroupReorderEvent({
    required  this.tableName,
    required this.items,
    required this.oldIndex,
    required this.newIndex,
  });
}

class CombinationGroupRenameEvent extends CombinationItemDbEvent{
  final int id;
  final String newGroupName;
  CombinationGroupRenameEvent({required this.id, required this.newGroupName});
}
