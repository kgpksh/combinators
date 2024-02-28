import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<bool?> showConfirmDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if(value == null) {
                Navigator.of(context).pop(false);
                return;
              }

              Navigator.of(context).pop(value);
              return;
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
