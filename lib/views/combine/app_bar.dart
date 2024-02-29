import 'package:combinators/enums/menu_action.dart';
import 'package:combinators/services/bloc/crud/group/combination_group_bloc.dart';
import 'package:combinators/views/utils/confirm_dialog.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CombinationAppBar extends AppBar{
  CombinationAppBar({super.key, required this.groupName, required this.groupId});
  final String groupName;
  final int groupId;

  @override
  State<CombinationAppBar> createState() => _CombinationAppBarState();
}

class _CombinationAppBarState extends State<CombinationAppBar> {
  late final String initialGroupName;
  late final int groupId;
  late String groupName;
  late CombinationGroupDbBloc bloc;

  @override
  void initState() {
    super.initState();
    initialGroupName = widget.groupName;
    groupName = widget.groupName;
    groupId = widget.groupId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<CombinationGroupDbBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    if (initialGroupName != groupName) {
      bloc.add(CombinationGroupLoadEvent());
    }
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(groupName),
      actions: [
        PopupMenuButton<CategoryMenuActions>(
          onSelected: (value) async {
            switch (value) {
              case CategoryMenuActions.editGroupName:
                final newGroupName = await showGenericDialog(
                  context: context,
                  title: 'Rename Group name',
                  defaultText: groupName,
                  hintText: 'Type Group name',
                  optionBuilder: () => {
                    'Cancel': null,
                    'Rename': true,
                  },
                );

                if (!context.mounted) return;
                if (newGroupName != null && newGroupName != '' && newGroupName != groupName) {
                  setState(() {
                    groupName = newGroupName;
                  });
                  context
                      .read<CombinationGroupDbBloc>()
                      .add(CombinationGroupRenameEvent(
                    id: groupId,
                    newGroupName: newGroupName,
                  ));
                }
              case CategoryMenuActions.deleteGroup:
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
                  context
                      .read<CombinationGroupDbBloc>()
                      .add(CombinationGroupDeleteEvent(groupId: groupId));

                  Navigator.of(context).pop();
                }
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<CategoryMenuActions>(
                value: CategoryMenuActions.editGroupName,
                child: Text('Rename Group'),
              ),
              const PopupMenuItem<CategoryMenuActions>(
                value: CategoryMenuActions.deleteGroup,
                child: Text('Delete Group'),
              ),
            ];
          },
        )
      ],
    );
  }
}
