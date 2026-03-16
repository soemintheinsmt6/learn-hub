import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:learn_hub/core/utils/app_color.dart';

class CompanyListShimmer extends StatelessWidget {
  const CompanyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleWidth = screenWidth - 200;
    final subtitleWidth = titleWidth - 40;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _linePlaceholder(titleWidth),
                      const SizedBox(height: 8),
                      _linePlaceholder(subtitleWidth),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _linePlaceholder(100),
                            const SizedBox(height: 8),
                            _progressPlaceholder(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _linePlaceholder(double width) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _progressPlaceholder() {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
