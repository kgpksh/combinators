import 'package:combinators/services/bloc/combination_result/combination_result_bloc.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:combinators/views/combine/combination_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> popupCombinationResult({
  required BuildContext context,
  required List<DatabaseCategory> categoryList,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (context) => CombinationResultBloc(),
        child: PopupCombination(
          categoryList: categoryList,
        ),
      );
    },
  );
}
