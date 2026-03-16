import 'package:flutter/material.dart';

Future<dynamic> pushView(BuildContext context, Widget widget) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) => widget),
  );

  return result;
}

Future<dynamic> pushViewHidingNavBar(
  BuildContext context,
  Widget widget,
) async {
  final result = await Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute(builder: (context) => widget));

  return result;
}
