import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
class DatabaseGroup extends ItemBaseEntity {
  DatabaseGroup({
    required super.id,
    required super.createdDate,
    required super.orderKey,
    required super.name,
  });

  DatabaseGroup.fromRow(Map<String, Object?> map)
      : super(
          id: map[idColumn] as int,
          createdDate: map[createdDateColumn] as String,
          orderKey: map[orderKeyColumn] as int,
          name: map[nameColumn] as String);

  @override
  String toString() => 'Group, Id =  $id, Name = $name, Key = $orderKey';

  @override
  bool operator ==(covariant DatabaseGroup other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
