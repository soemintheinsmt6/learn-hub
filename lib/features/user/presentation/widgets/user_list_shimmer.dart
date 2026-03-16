import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:learn_hub/core/utils/app_color.dart';

class UserListShimmer extends StatelessWidget {
  const UserListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final longWidth = MediaQuery.of(context).size.width - 150;
    final shortWidth = longWidth - 50;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 12,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textPlaceHolder(longWidth),
                  const SizedBox(height: 8),
                  _textPlaceHolder(shortWidth),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textPlaceHolder(double width) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

