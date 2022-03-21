import 'package:flutter/material.dart';

class SettingsText extends StatelessWidget {
  final String text;
  const SettingsText({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(text.toUpperCase(), style: Theme.of(context).textTheme.titleSmall),
          Expanded(
            child: Divider(
              indent: 10,
              color: Theme.of(context).textTheme.titleSmall!.color,
            ),
          ),
        ],
      ),
    );
  }
}
