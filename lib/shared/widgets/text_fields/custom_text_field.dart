import 'package:flutter/material.dart';

import 'package:learn_hub/core/utils/text_field_decoration.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    this.onChanged,
    this.obscureText = false,
  });

  final String title;
  final Function(String)? onChanged;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        TextField(
          decoration: kTextFieldDecoration.copyWith(hintText: title),
          obscureText: obscureText,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
