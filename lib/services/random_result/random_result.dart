import 'dart:math';

import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/services/crud/entity/item_entity.dart';

class RandomResult{
  List<List<String>> getRandomCombination({required List<DatabaseCategory> categoryList}) {
    // Map<String, String> result = {};
    List<List<String>> result = [];

    for(DatabaseCategory category in categoryList) {
      String categoryName = category.name;

      List<DatabaseItem> items = category.items;

      if(items.isEmpty) {
        // result[categoryName] = '';
        result.add([categoryName, '']);
        continue;
      }

      int randomItemIndex = Random().nextInt(items.length);
      // result[categoryName] = items[randomItemIndex].name;
      result.add([categoryName, items[randomItemIndex].name]);
    }

    return result;
  }
}