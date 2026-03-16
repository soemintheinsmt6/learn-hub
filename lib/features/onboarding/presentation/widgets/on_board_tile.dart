import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_hub/features/onboarding/domain/entities/on_board.dart';

class OnBoardTile extends StatelessWidget {
  const OnBoardTile({super.key, required this.item});

  final OnBoard item;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: width,
            child: SvgPicture.asset(item.image, fit: BoxFit.contain),
          ),
          SizedBox(
            height: 180,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 12),
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  item.desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
