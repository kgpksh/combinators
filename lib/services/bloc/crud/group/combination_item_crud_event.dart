part of 'combination_group_bloc.dart';

@immutable
abstract class CombinationGroupDbEvent {}

class CombinationGroupLoadEvent extends CombinationGroupDbEvent {}

class CombinationGroupCreateEvent extends CombinationGroupDbEvent {
  final String groupName;

  CombinationGroupCreateEvent({required this.groupName});
}

class CombinationGroupReorderEvent extends CombinationGroupDbEvent {
  final List<DatabaseGroup> items;
  final int oldIndex;
  final int newIndex;
  CombinationGroupReorderEvent({
    required this.items,
    required this.oldIndex,
    required this.newIndex,
  });
}

class CombinationGroupRenameEvent extends CombinationGroupDbEvent{
  final int id;
  final String newGroupName;
  CombinationGroupRenameEvent({required this.id, required this.newGroupName});
}

class CombinationGroupDeleteEvent extends CombinationGroupDbEvent{
  final int groupId;

  CombinationGroupDeleteEvent({required this.groupId});
}