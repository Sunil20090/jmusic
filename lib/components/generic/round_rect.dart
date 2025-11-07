import 'package:flutter/material.dart';
import 'package:jmusic/constants/theme_constant.dart';

class RoundRect extends StatelessWidget {
  final Widget child;
  final double radius;
  const RoundRect({super.key, required this.child, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_TRANSLUSCENT_WHITE,
        border: BoxBorder.all(width: 0.5, color: COLOR_TRANSLUSCENT_BLACK),
      
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
