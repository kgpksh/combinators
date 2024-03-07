import 'package:combinators/services/advertisement/rewarded_ad.dart';
import 'package:combinators/services/bloc/account/account_bloc.dart';
import 'package:combinators/services/bloc/combination_result/combination_result_bloc.dart';
import 'package:combinators/services/bloc/time_management/time_management_cubit.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:combinators/views/utils/loading_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupCombination extends StatefulWidget {
  const PopupCombination({
    super.key,
    required this.categoryList,
    required this.isSubscribing,
  });

  final List<DatabaseCategory> categoryList;
  final bool isSubscribing;

  @override
  State<PopupCombination> createState() => _PopupCombinationState();
}

class _PopupCombinationState extends State<PopupCombination> {
  double titleFontSize = DisplaySize.instance.displayHeight * 0.03;
  double cardHeight = DisplaySize.instance.displayHeight * 0.089;
  double singleItemPadding = DisplaySize.instance.displayWidth * 0.01;
  double singleListHeight = DisplaySize.instance.displayHeight * 0.12;
  double itemFontSize = DisplaySize.instance.displayHeight * 0.024;
  bool isSubscribing = false;

  @override
  void initState() {
    super.initState();
    context.read<CombinationResultBloc>().add(
          GetRandomCombinationResultEvent(
            categoryList: widget.categoryList,
          ),
        );
    isSubscribing = widget.isSubscribing;
  }

  @override
  Widget build(BuildContext context) {
    context.read<AccountBloc>().add(CheckAccountEvent());
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: SizedBox(
        height: DisplaySize.instance.displayHeight * 0.1,
        width: DisplaySize.instance.displayWidth,
        child: Container(
          padding: EdgeInsets.all(DisplaySize.instance.displayWidth * 0.01),
          color: Colors.blue,
          alignment: Alignment.centerRight,
          child: BlocBuilder<TimeManagementCubit, TimeManagementState>(
            builder: (context, state) {
              if (!isSubscribing) {
                context.read<TimeManagementCubit>().emitCheckResetTime();
              }
              if (!isSubscribing && state.currentRerollCount == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            size: DisplaySize.instance.displayWidth * 0.1,
                          )),
                    ),
                    Expanded(
                      flex: 16,
                      child: TextButton(
                        child: Text(
                          'Reroll count will reset at ${state.formattedDate()}!\nWatch AD and reset count now!',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          RewardedAdService().showRewardedAd();
                          context
                              .read<TimeManagementCubit>()
                              .forceResetRerollCount();
                        },
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          size: DisplaySize.instance.displayWidth * 0.1,
                        )),
                  ),
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Combination',
                            style: TextStyle(
                              fontSize: titleFontSize,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 9,
                                child: IconButton(
                                  onPressed: () {
                                    if (!isSubscribing) {
                                      context
                                          .read<TimeManagementCubit>()
                                          .decreaseRerollCount();
                                    }
                                    context.read<CombinationResultBloc>().add(
                                          GetRandomCombinationResultEvent(
                                            categoryList: widget.categoryList,
                                          ),
                                        );
                                  },
                                  icon: Icon(
                                    color: Colors.black,
                                    Icons.refresh_rounded,
                                    size:
                                        DisplaySize.instance.displayWidth * 0.1,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !isSubscribing,
                                child: Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${state.currentRerollCount}/$maxRerollCount left',
                                    style: TextStyle(fontSize: DisplaySize.instance.displayWidth * 0.03),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<CombinationResultBloc, CombinationResultState>(
            builder: (context, state) {
              if (state is GetRandomCombinationResultState) {
                List<List<String>> result = state.result;
                return ListView.builder(
                  itemCount: state.result.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: singleListHeight,
                      padding:
                          EdgeInsets.symmetric(horizontal: singleItemPadding),
                      child: Card(
                        semanticContainer: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: cardHeight,
                                child: Card(
                                  semanticContainer: true,
                                  color: Colors.redAccent,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        result[index].first,
                                        style: TextStyle(
                                          fontSize: itemFontSize,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: cardHeight,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              // 각나닫라맘바삿아잦차
                              child: SizedBox(
                                height: cardHeight,
                                child: Card(
                                  semanticContainer: true,
                                  color: Colors.greenAccent,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: result[index].last != ''
                                          ? Text(
                                              result[index].last,
                                              style: TextStyle(
                                                fontSize: itemFontSize,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : Text(
                                              'No item',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: itemFontSize,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const LoadingView();
            },
          ),
        ),
      ),
    );
  }
}