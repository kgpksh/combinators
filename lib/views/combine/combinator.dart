import 'package:combinators/enums/menu_action.dart';
import 'package:combinators/services/bloc/crud/combination_item_crud_bloc.dart';
import 'package:combinators/views/utils/confirm_dialog.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CombinationPage extends StatefulWidget {
  final String groupName;
  final int groupId;

  const CombinationPage(
      {super.key, required this.groupName, required this.groupId});

  @override
  State<CombinationPage> createState() => _CombinationPageState();
}

class _CombinationPageState extends State<CombinationPage> {
  late final String initialGroupName;
  late double height;
  late double width;
  late String groupName;
  late final int groupId;
  late CombinationItemDbBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    bloc = context.read<CombinationItemDbBloc>();
  }

  @override
  void initState() {
    super.initState();
    initialGroupName = widget.groupName;
    groupName = widget.groupName;
    groupId = widget.groupId;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          PopupMenuButton<CategoryMenuActions>(
            onSelected: (value) async {
              switch (value) {
                case CategoryMenuActions.editGroupName:
                  final newGroupName = await showGenericDialog(
                    context: context,
                    title: 'Edit group name',
                    defaultText: groupName,
                    hintText: 'Enter Group Name',
                    optionBuilder: () => {
                      'Cancel': null,
                      'Edit': true,
                    },
                  );

                  if (!context.mounted) return;
                  if (newGroupName != null) {
                    setState(() {
                      groupName = newGroupName;
                    });
                    context
                        .read<CombinationItemDbBloc>()
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
                        .read<CombinationItemDbBloc>()
                        .add(CombinationGroupDeleteEvent(groupId: groupId));

                    Navigator.of(context).pop();
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<CategoryMenuActions>(
                  value: CategoryMenuActions.editGroupName,
                  child: Text('Edit GroupName'),
                ),
                const PopupMenuItem<CategoryMenuActions>(
                  value: CategoryMenuActions.deleteGroup,
                  child: Text('Delete Group'),
                ),
              ];
            },
          )
        ],
      ),
      body: BlocBuilder<CombinationItemDbBloc, CombinationItemDbState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          // Colors.blueAccent,
                          Theme.of(context).primaryColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                          width * 0.4,
                          height * 0.1,
                        )),
                      ),
                      child: Text(
                        'Random combination',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          // 버튼을 눌렀을 때 실행할 코드를 여기에 작성하세요.
                        },
                        child: const Icon(Icons.add),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
