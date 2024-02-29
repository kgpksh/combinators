import 'package:combinators/enums/menu_action.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PopupMenuButton<ItemMenuActions> showItemPopupMenuButton({
  required BuildContext context,
  required List<DatabaseCategory> categoryList,
  required DatabaseCategory category,
  required int itemIndex,
}) {
  return PopupMenuButton<ItemMenuActions>(
    iconColor: Colors.black,
    onSelected: (value) async {
      switch (value) {
        case ItemMenuActions.renameItem:
          final newItemName = await showGenericDialog(
            context: context,
            title: 'Rename Item name',
            defaultText: category.items[itemIndex].name,
            hintText: 'Enter Item name',
            optionBuilder: () => {
              'Cancel': null,
              'Rename': true,
            },
          );

          if (!context.mounted) return;
          if (newItemName != null &&
              newItemName != '' &&
              newItemName != category.items[itemIndex].name) {
            context.read<CombinationBloc>().add(
                  CombinationItemRenameEvent(
                    categoryList: categoryList,
                    categoryId: category.id,
                    itemIndex: itemIndex,
                    newName: newItemName,
                  ),
                );
          }
        case ItemMenuActions.deleteItem:
          context.read<CombinationBloc>().add(
                CombinationItemDeleteEvent(
                    categoryList: categoryList,
                    categoryId: category.id,
                    itemIndex: itemIndex),
              );
      }
    },
    itemBuilder: (context) {
      return [
        const PopupMenuItem<ItemMenuActions>(
          value: ItemMenuActions.renameItem,
          child: Text('Rename item'),
        ),
        const PopupMenuItem<ItemMenuActions>(
          value: ItemMenuActions.deleteItem,
          child: Text('Delete item'),
        ),
      ];
    },
  );
}
