import 'package:combinators/services/advertisement/interstitial_ad.dart';
import 'package:combinators/services/bloc/account/account_bloc.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/bloc/time_management/time_management_cubit.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/combine/app_bar.dart';
import 'package:combinators/views/combine/category_popup_menu_button.dart';
import 'package:combinators/views/combine/cobination_result_popup.dart';
import 'package:combinators/views/combine/item_popup_menu_button.dart';
import 'package:combinators/views/utils/cached_reorderable_list_view.dart';
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
  double width = DisplaySize.instance.displayWidth;
  double floatingButtonSize = DisplaySize.instance.displayWidth * 0.13;
  double cardFontSize = DisplaySize.instance.displayWidth * 0.037;
  double categoryWidth = DisplaySize.instance.displayWidth * 0.35;
  double itemFontSize = DisplaySize.instance.displayHeight * 0.03;
  double randomButtonMinimumHeight = DisplaySize.instance.displayHeight * 0.1;
  double randomButtonMinimumWidth = DisplaySize.instance.displayHeight * 0.4;
  double itemCardHeight = DisplaySize.instance.displayHeight * 0.08;
  double marginBetweenCategoryAndItem =
      DisplaySize.instance.displayHeight * 0.01;
  late List<DatabaseCategory> combinationDatas;

  late final AccountBloc accountBloc;
  late final TimeManagementCubit timeManagementCubit;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context, listen: false);
    timeManagementCubit = BlocProvider.of<TimeManagementCubit>(context, listen: false);
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
          if (state is CombinationDbInitialState) {
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
                      Expanded(
                        flex: 6,
                        child: BlocBuilder<AccountBloc, AccountState>(
                          builder: (context, state) {
                            bool isSubscribing = state is AccountSubscribed;
                            return ElevatedButton(
                              onPressed: () {
                                if(combinationDatas.isEmpty) {
                                  return;
                                }
                                if (!isSubscribing) {
                                  InterstitialAdService().showInterstitialAd();
                                }
                                BuildContext dialogContext = context;
                                popupCombinationResult(
                                  context: dialogContext,
                                  categoryList: combinationDatas,
                                  accountBloc: accountBloc,
                                  timeManagementCubit: timeManagementCubit,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(Size(
                                  randomButtonMinimumWidth,
                                  randomButtonMinimumHeight,
                                )),
                              ),
                              child: Text(
                                combinationDatas.isNotEmpty ? 'Random combination' : 'No category',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: itemFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: floatingButtonSize,
                          height: floatingButtonSize,
                          child: FittedBox(
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

                                if (categoryName != null &&
                                    categoryName != '') {
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
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: marginBetweenCategoryAndItem,
                  ),
                  Expanded(
                    child: CachedReorderableListView(
                      scrollDirection: Axis.horizontal,
                      list: combinationDatas,
                      itemBuilder: (context, item) {
                        return SizedBox(
                          width: categoryWidth,
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
                                    semanticContainer: true,
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
                                                fontSize: cardFontSize,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child:
                                                showCategoryPopupMenuButtons(
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
                                        height: itemCardHeight,
                                        child: Card(
                                          color: Colors.greenAccent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Center(
                                                  child: Text(
                                                    item.items[index].name,
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: cardFontSize,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child:
                                                    showItemPopupMenuButton(
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
