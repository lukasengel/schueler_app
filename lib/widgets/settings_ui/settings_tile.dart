import 'package:flutter/material.dart';
import './settings_container.dart';

class SettingsTile extends StatelessWidget {
  final String label;
  final Icon icon;
  final Function() onTap;

  const SettingsTile(
      {required this.label, required this.icon, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ],
      ),
    );
  }
}
