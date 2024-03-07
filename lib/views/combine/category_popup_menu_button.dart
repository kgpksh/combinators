import 'package:combinators/enums/menu_action.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/utils/confirm_dialog.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PopupMenuButton<CategoryItemMenuActions> showCategoryPopupMenuButtons({
  required BuildContext context,
  required DatabaseCategory item,
  required List<DatabaseCategory> combinationDatas,
}) {
  double popupMenuSize = DisplaySize.instance.displayHeight * 0.03;
  double itemHeight = DisplaySize.instance.displayHeight * 0.06;
  double itemWidth = DisplaySize.instance.displayWidth * 0.15;
  double fontSize = DisplaySize.instance.displayWidth * 0.03;
  return PopupMenuButton<CategoryItemMenuActions>(
    icon: Icon(
      Icons.more_vert,
      size: popupMenuSize,
    ),
    iconColor: Colors.black,
    onSelected: (value) async {
      switch (value) {
        case CategoryItemMenuActions.addItem:
          final itemName = await showGenericDialog(
            context: context,
            title: 'Add Category',
            defaultText: '',
            hintText: 'Type Category Name',
            optionBuilder: () => {
              'Cancel': null,
              'Create': true,
            },
          );

          if (!context.mounted) return;
          if (itemName != null && itemName != '') {
            context.read<CombinationBloc>().add(
                  CombinationItemCreateEvent(
                    groupId: item.groupId,
                    categoryId: item.id,
                    name: itemName,
                  ),
                );
          }

        case CategoryItemMenuActions.editCategoryName:
          final newCategoryName = await showGenericDialog(
            context: context,
            title: 'Rename category name',
            defaultText: item.name,
            hintText: 'Enter Category name',
            optionBuilder: () => {
              'Cancel': null,
              'Rename': true,
            },
          );

          if (!context.mounted) return;
          if (newCategoryName != null &&
              newCategoryName != '' &&
              newCategoryName != item.name) {
            context.read<CombinationBloc>().add(
                  CombinationCategoryRenameEvent(
                    categoryList: combinationDatas,
                    id: item.id,
                    newCategoryName: newCategoryName,
                  ),
                );
          }
        case CategoryItemMenuActions.deleteCategory:
          final bool? deleteCommand = await showConfirmDialog(
            context: context,
            title: 'Confirm',
            content: 'Will you really delete this group?',
            optionBuilder: () => {
              'Cancel': false,
              'Delete': true,
            },
          );

          if (!context.mounted) return;
          if (deleteCommand ?? false) {
            context.read<CombinationBloc>().add(
                  CombinationCategoryDeleteEvent(
                    categoryId: item.id,
                    categoryList: combinationDatas,
                  ),
                );
          }
      }
    },
    itemBuilder: (context) {
      return [
        PopupMenuItem<CategoryItemMenuActions>(
          value: CategoryItemMenuActions.addItem,
          child: SizedBox(
            height: itemHeight,
            width: itemWidth,
            child: Center(
              child: Text(
                textAlign: TextAlign.left,
                'Add item',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ),
        PopupMenuItem<CategoryItemMenuActions>(
          value: CategoryItemMenuActions.editCategoryName,
          child: SizedBox(
            height: itemHeight,
            width: itemWidth,
            child: Center(
              child: Text(
                textAlign: TextAlign.left,
                'Rename Category',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ),
        PopupMenuItem<CategoryItemMenuActions>(
          value: CategoryItemMenuActions.deleteCategory,
          child: SizedBox(
            height: itemHeight,
            width: itemWidth,
            child: Center(
              child: Text(
                textAlign: TextAlign.left,
                'Delete Category',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ),
      ];
    },
  );
}
