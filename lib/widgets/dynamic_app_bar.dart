import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

PreferredSizeWidget dynamicAppBar({
  required BuildContext context,
  required String title,
  DynamicAppBarAction? leading,
  DynamicAppBarAction? action,
  bool canGoBack = true,
}) {
  if (Platform.isIOS) {
    return CupertinoNavigationBar(
      brightness: Brightness.dark,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      leading: canGoBack && leading == null
          ? _backButton._toCupertinoButton(context)
          : leading?._toCupertinoButton(context),
      middle: Text(title, style: context.theme.appBarTheme.titleTextStyle),
      trailing: action?._toCupertinoButton(context),
    );
  }
  return AppBar(
    title: Text(title),
    leading: leading?._toIconButton(context),
    actions: [if (action != null) action._toIconButton(context)],
  );
}

final _backButton = DynamicAppBarAction(
  icon: Icons.arrow_back_ios,
  onPressed: Get.back,
);

class DynamicAppBarAction {
  final IconData icon;
  final Function()? onPressed;
  RxBool? enabled;

  DynamicAppBarAction({
    required this.icon,
    required this.onPressed,
    this.enabled,
  });

  Widget _toIconButton(BuildContext context) {
    if (enabled != null) {
      return Obx(() => IconButton(
            onPressed: enabled!.value ? onPressed : null,
            icon: Icon(
              icon,
              color: enabled!.value
                  ? context.theme.appBarTheme.foregroundColor
                  : Colors.grey,
            ),
          ));
    }
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: context.theme.appBarTheme.foregroundColor),
    );
  }

  Widget _toCupertinoButton(BuildContext context) {
    if (enabled != null) {
      return Obx(() => CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              icon,
              color: enabled!.value
                  ? context.theme.appBarTheme.foregroundColor
                  : Colors.grey,
            ),
            minSize: 0,
            onPressed: enabled!.value ? onPressed : null,
          ));
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(icon, color: context.theme.appBarTheme.foregroundColor),
      minSize: 0,
      onPressed: onPressed,
    );
  }
}
