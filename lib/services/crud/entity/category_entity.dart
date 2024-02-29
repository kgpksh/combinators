import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:combinators/services/crud/entity/item_entity.dart';
import 'package:flutter/foundation.dart';

const String categoryGroupIdColumn = 'group_id';
const String categoryItemListColumn = 'items';

@immutable
class DatabaseCategory extends ItemBaseEntity {
  final int groupId;
  final List<DatabaseItem> items;

  DatabaseCategory({
    required super.id,
    required super.createdDate,
    required this.groupId,
    required super.orderKey,
    required super.name,
    required this.items,
  });

  DatabaseCategory.fromRow(Map<String, Object?> map)
      : groupId = map[categoryGroupIdColumn] as int,
        items= map[categoryItemListColumn] as List<DatabaseItem>,
        super(
          id: map[idColumn] as int,
          createdDate: map[createdDateColumn] as String,
          orderKey: map[orderKeyColumn] as int,
          name: map[nameColumn] as String,);

  @override
  String toString() =>
      'Category, Id =  $id, Name = $name, GroupId = $groupId, Key = $orderKey';

  @override
  bool operator ==(covariant DatabaseCategory other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
