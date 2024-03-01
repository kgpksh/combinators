import 'dart:math';

import 'package:combinators/views/utils/display_size.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String defaultText,
  required String hintText,
  required DialogOptionBuilder optionBuilder,
}) {
  double dialogWidth = max(DisplaySize.instance.displayWidth * 0.1, 400);
  double dialogHeight = max(DisplaySize.instance.displayHeight * 0.08, 80);
  double titleSize = DisplaySize.instance.displayWidth * 0.05;
  double contentSize = DisplaySize.instance.displayWidth * 0.04;
  double textButtonSize = DisplaySize.instance.displayWidth * 0.03;
  final options = optionBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: defaultText);
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: titleSize),),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: TextFormField(
              style: TextStyle(fontSize: contentSize),
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                counterStyle: TextStyle(fontSize: contentSize),
              ),
              maxLength: 10,
            ),
          ),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  String? result;
                  if(controller.text.isNotEmpty) {
                    result = controller.text;
                  }

                  Navigator.of(context).pop(result);
                } else {
                  Navigator.of(context).pop(null);
                }
              },
              child: Text(optionTitle, style: TextStyle(fontSize: textButtonSize),)
            );
          }).toList(),
        );
      });
}
