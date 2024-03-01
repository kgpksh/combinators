import 'dart:math';

import 'package:combinators/views/utils/display_size.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<bool?> showConfirmDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  double dialogWidth = max(DisplaySize.instance.displayWidth * 0.1, 400);
  double dialogHeight = max(DisplaySize.instance.displayHeight * 0.08, 100);
  double titleSize = DisplaySize.instance.displayWidth * 0.08;
  double contentSize = DisplaySize.instance.displayWidth * 0.03;
  double textButtonSize = DisplaySize.instance.displayWidth * 0.03;
  final options = optionBuilder();
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: titleSize),),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Text(content, style: TextStyle(fontSize: contentSize),),
        ),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(

            onPressed: () {
              if (value == null) {
                Navigator.of(context).pop(false);
                return;
              }

              Navigator.of(context).pop(value);
              return;
            },
            child: Text(optionTitle, style: TextStyle(fontSize: textButtonSize),)
          );
        }).toList(),
      );
    },
  );
}
