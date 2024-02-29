part of 'combination_bloc.dart';

@immutable
abstract class CombinationEvent {}

class CombinationCategoryCreateEvent extends CombinationEvent {
  final int groupId;
  final String name;

  CombinationCategoryCreateEvent({required this.groupId, required this.name});
}

class CombinationPageLoadEvent extends CombinationEvent {
  final int groupId;

  CombinationPageLoadEvent({required this.groupId});
}

class CombinationCategoryRenameEvent extends CombinationEvent {
  final List<DatabaseCategory> categoryList;
  final int id;
  final String newCategoryName;

  CombinationCategoryRenameEvent({
    required this.categoryList,
    required this.id,
    required this.newCategoryName,
  });
}

class CombinationCategoryReorderEvent extends CombinationEvent {
  final int groupId;
  final List<DatabaseCategory> items;
  final int oldIndex;
  final int newIndex;

  CombinationCategoryReorderEvent({
    required this.groupId,
    required this.items,
    required this.oldIndex,
    required this.newIndex,
  });
}

class CombinationCategoryDeleteEvent extends CombinationEvent {
  final int categoryId;
  final List<DatabaseCategory> categoryList;

  CombinationCategoryDeleteEvent({
    required this.categoryId,
    required this.categoryList,
  });
}

class CombinationItemCreateEvent extends CombinationEvent {
  final int groupId;
  final int categoryId;
  final String name;

  CombinationItemCreateEvent(
      {required this.groupId, required this.categoryId, required this.name});
}

class CombinationItemRenameEvent extends CombinationEvent {
  final List<DatabaseCategory> categoryList;
  final int categoryId;
  final int itemIndex;
  final String newName;

  CombinationItemRenameEvent({
    required this.categoryList,
    required this.itemIndex,
    required this.categoryId,
    required this.newName,
  });
}

class CombinationItemDeleteEvent extends CombinationEvent {
  final List<DatabaseCategory> categoryList;
  final int categoryId;
  final int itemIndex;

  CombinationItemDeleteEvent({
    required this.categoryList,
    required this.categoryId,
    required this.itemIndex,
  });
}
