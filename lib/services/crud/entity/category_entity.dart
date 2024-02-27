import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:flutter/foundation.dart';

const String categoryGroupIdColumn = 'group_id';

@immutable
class DatabaseCategory extends ItemBaseEntity {
  final int groupId;

  DatabaseCategory({
    required super.id,
    required super.createdDate,
    required this.groupId,
    required super.orderKey,
    required super.name,
  });

  DatabaseCategory.fromRow(Map<String, Object?> map)
      : groupId = map[categoryGroupIdColumn] as int,
        super(
          id: map[idColumn] as int,
          createdDate: map[createdDateColumn] as String,
          orderKey: map[orderKeyColumn] as int,
          name: map[nameColumn] as String);

  @override
  String toString() =>
      'Category, Id =  $id, Name = $name, GroupId = $groupId, Key = $orderKey';

  @override
  bool operator ==(covariant DatabaseCategory other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
