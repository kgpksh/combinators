import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String defaultText,
  required String hintText,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: defaultText);
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            maxLength: 10,
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
              child: Text(optionTitle),
            );
          }).toList(),
        );
      });
}
