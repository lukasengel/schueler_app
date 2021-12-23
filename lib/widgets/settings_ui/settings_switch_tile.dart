import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './settings_container.dart';

class SettingsSwitchTile extends StatefulWidget {
  final Future<bool> Function(bool) onChanged;
  final String label;
  bool value;

  SettingsSwitchTile({
    required this.label,
    required this.onChanged,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile> {
  void onChanged(val) async {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    setState(() => widget.value = val);
    final input = await widget.onChanged(val);
    setState(() => widget.value = input);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      onTap: () => onChanged(!widget.value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).primaryColor,
            value: widget.value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
