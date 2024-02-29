import 'package:combinators/enums/menu_action.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/combine/app_bar.dart';
import 'package:combinators/views/combine/category_popup_menu_button.dart';
import 'package:combinators/views/combine/item_popup_menu_button.dart';
import 'package:combinators/views/utils/cached_reorderable_list_view.dart';
import 'package:combinators/views/utils/confirm_dialog.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:combinators/views/utils/loading_view.dart';
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
  late double height;
  late double width;
  late List<DatabaseCategory> combinationDatas;

  @override
  void initState() {
    super.initState();
    height = DisplaySize.instance.displayHeight;
    width = DisplaySize.instance.displayWidth;
    context
        .read<CombinationBloc>()
        .add(CombinationPageLoadEvent(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CombinationAppBar(
          groupName: widget.groupName, groupId: widget.groupId),
      body: BlocBuilder<CombinationBloc, CombinationState>(
        buildWhen: (context, state) => state is CombinationPageLoadedState,
        builder: (context, state) {
          if(state is CombinationDbInitialState) {
            return const LoadingView();
          }
          if (state is CombinationPageLoadedState) {
            combinationDatas = List.of(state.combinationData);
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
                            Colors.blueAccent,
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
                          onPressed: () async {
                            final categoryName = await showGenericDialog(
                              context: context,
                              title: 'Add Category',
                              defaultText: '',
                              hintText: 'Enter Category Name',
                              optionBuilder: () => {
                                'Cancel': null,
                                'Create': true,
                              },
                            );

                            if (!context.mounted) return;

                            if (categoryName != null && categoryName != '') {
                              context.read<CombinationBloc>().add(
                                    CombinationCategoryCreateEvent(
                                      groupId: widget.groupId,
                                      name: categoryName,
                                    ),
                                  );
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: CachedReorderableListView(
                      scrollDirection: Axis.horizontal,
                      list: combinationDatas,
                      itemBuilder: (context, item) {
                        return SizedBox(
                          width: width * 0.35,
                          key: Key('${item.orderKey}'),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    color: Colors.redAccent,
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Text(
                                              item.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width * 0.037,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: showCategoryPopupMenuButtons(
                                                context: context,
                                                item: item,
                                                combinationDatas:
                                                    combinationDatas),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: ListView.builder(
                                    itemCount: item.items.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: height * 0.08,
                                        child: Card(
                                          color: Colors.greenAccent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Center(
                                                  child: Text(
                                                    item.items[index].name,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: showItemPopupMenuButton(
                                                  context: context,
                                                  categoryList:
                                                      combinationDatas,
                                                  category: item,
                                                  itemIndex: index,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        context
                            .read<CombinationBloc>()
                            .add(CombinationCategoryReorderEvent(
                              groupId: widget.groupId,
                              items: combinationDatas,
                              oldIndex: oldIndex,
                              newIndex: newIndex,
                            ));
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const LoadingView();
        },
      ),
    );
  }
}
