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
          Expanded(child: icon),
          const SizedBox(width: 10),
          Expanded(flex: 8, child: Text(label)),
          const Expanded(child: Icon(Icons.chevron_right, color: Colors.grey)),
        ],
      ),
    );
  }
}
