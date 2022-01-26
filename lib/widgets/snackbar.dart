import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required SnackBar snackbar,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
