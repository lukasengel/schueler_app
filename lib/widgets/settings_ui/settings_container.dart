import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  const SettingsContainer(
      {required this.child, this.onTap, this.padding, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
