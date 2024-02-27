import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/services/crud/entity/group_entity.dart';
import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:combinators/services/crud/entity/item_entity.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:combinators/services/crud/combination_item_repository_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CombinationItemRepository {
  static final CombinationItemRepository _combinationItemRepository =
      CombinationItemRepository._sharedInstance();

  CombinationItemRepository._sharedInstance();

  factory CombinationItemRepository() => _combinationItemRepository;
  Database? _db;

  Future<int> deleteGroup({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    return db.delete(groupTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ItemBaseEntity>> updateEntityKey({
    required String tableName,
    required List<ItemBaseEntity> items,
    required int oldIndex,
    required int newIndex,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final List<ItemBaseEntity> slicedList;
    if (oldIndex < newIndex) {
      slicedList = items.getRange(oldIndex, newIndex + 1).toList();
      ItemBaseEntity moved = slicedList.removeAt(0);
      slicedList.add(moved);
      for (ItemBaseEntity item in slicedList) {
        item.orderKey -= 1;
      }
      slicedList[newIndex - oldIndex].orderKey = newIndex + 1;
    } else {
      slicedList = items.getRange(newIndex, oldIndex + 1).toList();
      ItemBaseEntity moved = slicedList.removeAt(oldIndex - newIndex);
      for (ItemBaseEntity item in slicedList) {
        item.orderKey += 1;
      }
      moved.orderKey = newIndex + 1;
      slicedList.insert(0, moved);
    }

    final batch = db.batch();
    for (final ItemBaseEntity item in slicedList) {
      batch.update(groupTable, {orderKeyColumn: item.orderKey},
          where: 'id = ?', whereArgs: [item.id]);
    }

    await batch.commit(continueOnError: false);

    if (tableName == groupTable) {
      return getAllGroups();
    } else if (tableName == categoryTable) {
      return getAllCategories();
    } else {
      return getAllItems();
    }
  }

  Future<int> updateEntityName({required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    return db.update(groupTable, {nameColumn: name});
  }

  Future<List<DatabaseGroup>> createGroup({required String name}) async {
    final latestOrderKey = await getLatestOrderKey(tableName: groupTable);
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(groupTable, {
      createdDateColumn: DateFormat("yyyy - MM - dd").format(DateTime.now()),
      orderKeyColumn: latestOrderKey + 1,
      nameColumn: name,
    });

    return getAllGroups();
  }

  Future<int> getLatestOrderKey({required String tableName}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final latest = await db.query(
      tableName,
      orderBy: '$idColumn DESC',
      limit: 1,
    );

    int latestId = 0;
    if (latest.isNotEmpty) {
      latestId = latest[0][idColumn] as int;
    }

    return latestId;
  }

  Future<List<DatabaseGroup>> getAllGroups() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final groups = await db.query(
      groupTable,
      orderBy: '$orderKeyColumn ASC',
    );
    return groups.map((group) => DatabaseGroup.fromRow(group)).toList();
  }

  Future<List<DatabaseCategory>> getAllCategories() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final categories = await db.query(
      groupTable,
      orderBy: '$orderKeyColumn ASC',
    );
    return categories
        .map((category) => DatabaseCategory.fromRow(category))
        .toList();
  }

  Future<List<DatabaseItem>> getAllItems() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final items = await db.query(
      groupTable,
      orderBy: '$orderKeyColumn ASC',
    );
    return items.map((item) => DatabaseItem.fromRow(item)).toList();
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await databaseFactorySqflitePlugin.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onConfigure: _onConfigure,
          onCreate: (db, version) async {
            var batch = db.batch();
            _createTableGroupV1(batch);
            _createTableCategoryV1(batch);
            _createTableItemV1(batch);
            await batch.commit();
          },
          onDowngrade: onDatabaseDowngradeDelete,
        ),
      );
      _db = db;
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

void _createTableGroupV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS "$groupTable"');
  batch.execute(createGroupTable);
}

void _createTableCategoryV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS "$categoryTable"');
  batch.execute(createCategoryTable);
  batch.execute(createCategoryIndex);
}

void _createTableItemV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS "$itemTable"');
  batch.execute(createItemTable);
  batch.execute(createItemIndex);
}

const dbName = 'combinators.db';
const groupTable = 'group';
const categoryTable = 'category';
const itemTable = 'item';

const Map<String, dynamic> tableMap = {
  groupTable: DatabaseGroup,
  categoryTable: DatabaseCategory,
  itemTable: DatabaseItem
};

const createGroupTable = '''
    CREATE TABLE IF NOT EXISTS "$groupTable" (
      "id" INTEGER NOT NULL,
      "created_date" TEXT NOT NULL,
      "order_key" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT));
  ''';

const createCategoryTable = '''
    CREATE TABLE IF NOT EXISTS "$categoryTable" (
      "id" INTEGER NOT NULL,
      "created_date" TEXT NOT NULL,
      "group_id" INTEGER NOT NULL,
      "order_key" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      FOREIGN KEY(group_id) REFERENCES "$groupTable"(id) ON DELETE CASCADE,
      PRIMARY KEY("id" AUTOINCREMENT));
  ''';

const createCategoryIndex = 'CREATE INDEX IF NOT EXISTS idx_category_group_id ON "$categoryTable" (group_id);';

const createItemTable = '''
    CREATE TABLE IF NOT EXISTS "$itemTable" (
      "id" INTEGER NOT NULL,
      "created_date" TEXT NOT NULL,
      "category_id" INTEGER NOT NULL,
      "order_key" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      FOREIGN KEY(category_id) REFERENCES "$categoryTable"(id) ON DELETE CASCADE,
      PRIMARY KEY("id" AUTOINCREMENT));
  ''';

const createItemIndex = 'CREATE INDEX IF NOT EXISTS idx_item_category_id ON "$itemTable" (category_id);';
