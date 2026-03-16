import 'package:flutter/material.dart';
import 'package:native_dialog_plus/native_dialog_plus.dart';

void showAlert(
  BuildContext context, {
  String title = 'Error!',
  required String message,
  String buttonTitle = 'Dismiss',
}) {
  NativeDialogPlus(
    title: title,
    message: message,
    actions: [
      NativeDialogPlusAction(
        text: buttonTitle,
        style: NativeDialogPlusActionStyle.defaultStyle,
        onPressed: () {},
      ),
    ],
  ).show();
}
