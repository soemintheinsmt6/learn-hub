import 'package:flutter/material.dart';
import 'package:learn_hub/core/utils/app_color.dart';

class BarButton extends StatelessWidget {
  const BarButton({super.key, required this.title, this.onTap});

  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary,
        ),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
