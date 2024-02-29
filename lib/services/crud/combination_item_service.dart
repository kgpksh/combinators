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

  Future<List<DatabaseCategory>> deleteItem({
    required List<DatabaseCategory> categoryList,
    required int categoryId,
    required int itemIndex,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    int updateCategoryIndex =
        categoryList.indexWhere((element) => element.id == categoryId);
    int itemId = categoryList[updateCategoryIndex].items[itemIndex].id;
    await db.delete(itemTable, where: 'id = ?', whereArgs: [itemId]);

    categoryList[updateCategoryIndex].items.removeAt(itemIndex);
    return categoryList;
  }

  Future<List<DatabaseCategory>> deleteCategory({
    required List<DatabaseCategory> categoryList,
    required int id,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.delete(categoryTable, where: 'id = ?', whereArgs: [id]);

    categoryList.removeWhere((element) => element.id == id);
    return categoryList;
  }

  Future<int> deleteGroup({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    return db.delete(groupTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DatabaseCategory>> updateItemName({
    required List<DatabaseCategory> categoryList,
    required int categoryId,
    required int itemIndex,
    required newName,
  }) async {
    int updateCategoryIndex =
        categoryList.indexWhere((element) => element.id == categoryId);
    DatabaseItem item = categoryList[updateCategoryIndex].items[itemIndex];

    await _updateEntityName(
        id: item.id, tableName: itemTable, newName: newName);

    categoryList[updateCategoryIndex].items[itemIndex].name = newName;
    return categoryList;
  }

  Future<List<DatabaseCategory>> updateCategoryName({
    required List<DatabaseCategory> categoryList,
    required int id,
    required newName,
  }) async {
    await _updateEntityName(id: id, tableName: categoryTable, newName: newName);
    int updateIndex = categoryList.indexWhere((element) => element.id == id);
    categoryList[updateIndex].name = newName;
    return categoryList;
  }

  Future<List<DatabaseGroup>> updateGroupName(
      {required int id, required newName}) async {
    await _updateEntityName(id: id, tableName: groupTable, newName: newName);
    return await getAllGroups();
  }

  Future<List<DatabaseCategory>> updateCategoryKey({
    required List<DatabaseCategory> combinationList,
    required int oldIndex,
    required int newIndex,
    required int groupId,
  }) async {
    DatabaseCategory item = combinationList.removeAt(oldIndex);
    combinationList.insert(newIndex, item);

    await updateEntityKey(
      tableName: categoryTable,
      items: combinationList,
    );

    return combinationList;
  }

  Future<List<DatabaseGroup>> updateGroupKey({
    required List<DatabaseGroup> groupList,
    required int oldIndex,
    required int newIndex,
  }) async {
    DatabaseGroup item = groupList.removeAt(oldIndex);
    groupList.insert(newIndex, item);

    await updateEntityKey(
      tableName: groupTable,
      items: groupList,
    );

    return groupList;
  }

  Future<void> updateEntityKey({
    required String tableName,
    required List<ItemBaseEntity> items,
    // required int oldIndex,
    // required int newIndex,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final batch = db.batch();
    for (int index = 0; index < items.length; index++) {
      batch.update(tableName, {orderKeyColumn: index},
          where: 'id = ?', whereArgs: [items[index].id]);
    }

    await batch.commit(continueOnError: false);
  }

  Future<int> _updateEntityName(
      {required int id,
      required String tableName,
      required String newName}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    return db.update(tableName, {nameColumn: newName},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> createItem(
      {required int categoryId, required String name}) async {
    final latestOrderKey = await getLatestOrderKey(tableName: itemTable);
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await db.insert(itemTable, {
      itemCategoryIdColumn: categoryId,
      createdDateColumn: DateFormat("yyyy - MM - dd").format(DateTime.now()),
      orderKeyColumn: latestOrderKey + 1,
      nameColumn: name,
    });
  }

  Future<void> createCategory(
      {required int groupId, required String name}) async {
    final latestOrderKey = await getLatestOrderKey(tableName: categoryTable);
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await db.insert(categoryTable, {
      categoryGroupIdColumn: groupId,
      createdDateColumn: DateFormat("yyyy - MM - dd").format(DateTime.now()),
      orderKeyColumn: latestOrderKey + 1,
      nameColumn: name,
    });
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

  Future<List<DatabaseCategory>> getCombinationDatas({
    required int groupId,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    return await db.transaction((txn) async {
      // 먼저 해당 groupId에 맞는 category들을 쿼리합니다.
      final List<Map<String, dynamic>> categoryList = await txn.query(
        categoryTable,
        where: 'group_id = ?',
        whereArgs: [groupId],
        orderBy: 'order_key ASC',
      );

      List<Map<String, dynamic>> categories = [];

      // 각 category에 대해 item들을 쿼리하고, 결과를 합치는 작업을 수행합니다.
      for (var category in categoryList) {
        final List<Map<String, dynamic>> itemList = await txn.query(
          itemTable,
          where: 'category_id = ?',
          whereArgs: [category['id']],
          orderBy: 'order_key ASC',
        );

        final List<DatabaseItem> items =
            itemList.map((item) => DatabaseItem.fromRow(item)).toList();

        // category에 속한 item들을 'items'라는 key로 추가합니다.
        category = Map.of(category);
        category['items'] = items;
        categories.add(category);
      }

      return categories
          .map((category) => DatabaseCategory.fromRow(category))
          .toList();
    });
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

const createCategoryIndex =
    'CREATE INDEX IF NOT EXISTS idx_category_group_id ON "$categoryTable" (group_id);';

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

const createItemIndex =
    'CREATE INDEX IF NOT EXISTS idx_item_category_id ON "$itemTable" (category_id);';
