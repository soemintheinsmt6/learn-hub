import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_hub/core/utils/app_color.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(child: SpinKitSpinningLines(color: AppColors.primary)),
      ),
    );
  }
}
