import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  const SvgImage({
    super.key,
    required this.name,
    this.width = 24.0,
    this.height = 24.0,
    this.semanticsLabel = 'Button',
    this.color = Colors.black,
    this.isIcon = true,
  });

  final String name;
  final double width;
  final double height;
  final String semanticsLabel;
  final Color color;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    final image = isIcon ? 'images/icons/$name.svg' : 'images/$name.svg';
    return SvgPicture.asset(
      image,
      width: width,
      height: height,
      semanticsLabel: semanticsLabel,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
