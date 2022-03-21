import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './settings_container.dart';

class SettingsSwitchTile extends StatefulWidget {
  final Future<bool> Function() onChanged;
  final String label;
  final bool value;

  const SettingsSwitchTile({
    required this.label,
    required this.onChanged,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile> {
  late bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  void onChanged(val) async {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    setState(() => value = val);
    final input = await widget.onChanged();
    setState(() => value = input);
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
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
