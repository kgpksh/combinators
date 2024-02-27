import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:flutter/foundation.dart';

const String itemCategoryIdColumn = 'category_id';

@immutable
class DatabaseItem extends ItemBaseEntity {
  final int categoryId;

  DatabaseItem({
    required super.id,
    required super.createdDate,
    required this.categoryId,
    required super.orderKey,
    required super.name,
  });

  DatabaseItem.fromRow(Map<String, Object?> map)
      : categoryId = map[itemCategoryIdColumn] as int,
        super(
            id: map[idColumn] as int,
            createdDate: map[createdDateColumn] as String,
            orderKey: map[orderKeyColumn] as int,
            name: map[nameColumn] as String);

  @override
  String toString() =>
      'Group, Id =  $id, Name = $name, categoryId = $categoryId, Key = $orderKey';

  @override
  bool operator ==(covariant DatabaseItem other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
