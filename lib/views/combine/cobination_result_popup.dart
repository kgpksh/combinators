import 'package:combinators/services/bloc/account/account_bloc.dart';
import 'package:combinators/services/bloc/combination_result/combination_result_bloc.dart';
import 'package:combinators/services/bloc/time_management/time_management_cubit.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/combine/combination_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> popupCombinationResult({
  required BuildContext context,
  required List<DatabaseCategory> categoryList,
  required CombinationResultBloc combinationResultBloc,
  required AccountBloc accountBloc,
  required bool isSubscribing,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<CombinationResultBloc>.value(
            value: combinationResultBloc,
          ),
          BlocProvider<AccountBloc>.value(
            value: accountBloc,
          ),
          BlocProvider(
            create: (context) => TimeManagementCubit(),
          ),
        ],
        child: PopupCombination(
          categoryList: categoryList,
          isSubscribing: isSubscribing,
        ),
      );
    },
  );
}
