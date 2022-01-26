import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> showDynamicMessageDialog({
  required BuildContext context,
  String? title,
  Widget? content,
}) {
  return Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: title != null && title.isNotEmpty ? Text(title) : null,
            content: content,
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
        )
      : showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: title != null && title.isNotEmpty ? Text(title) : null,
            content: content,
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
        );
}
