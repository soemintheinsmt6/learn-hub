import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
