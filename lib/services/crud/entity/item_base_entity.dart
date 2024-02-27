import 'package:flutter/foundation.dart';

const String idColumn = 'id';
const String orderKeyColumn = 'order_key';
const String nameColumn = 'name';
const String createdDateColumn = 'created_date';

@immutable
abstract class ItemBaseEntity {
  final int id;
  int orderKey;
  String name;
  String  createdDate;

  ItemBaseEntity({
    required this.id,
    required this.createdDate,
    required this.orderKey,
    required this.name,

  });

  @override
  bool operator ==(covariant ItemBaseEntity other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
