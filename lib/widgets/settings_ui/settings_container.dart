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
    const defaultPadding = EdgeInsets.symmetric(horizontal: 15, vertical: 8);
    const defaultMargin = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    if (onTap == null) {
      return Container(
        margin: defaultMargin,
        padding: padding ?? defaultPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(child: child, color: Colors.transparent),
      );
    }

    return Padding(
      padding: defaultMargin,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.tertiary,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: padding ?? defaultPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
