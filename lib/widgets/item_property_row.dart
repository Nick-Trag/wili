import 'package:flutter/material.dart';

// Used in the ViewItemWidget, to show one single property as a row, with an icon and some text
class ItemPropertyRowWidget extends StatelessWidget {
  const ItemPropertyRowWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  final Icon icon;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: icon,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            ),
            child: text,
          ),
        ),
      ],
    );
  }
}