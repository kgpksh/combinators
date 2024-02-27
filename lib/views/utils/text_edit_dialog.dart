import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  final controller = TextEditingController();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter Group Name",
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
              child: Text(optionTitle),
            );
          }).toList(),
        );
      });
}
