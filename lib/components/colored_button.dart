import 'package:jmusic/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ColoredButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final double radius;
  ColoredButton({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor = COLOR_PRIMARY,
    this.radius = 18,
  });

  @override
  State<ColoredButton> createState() => _ColoredButtonState();
}

class _ColoredButtonState extends State<ColoredButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: CONTENT_PADDING,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: widget.child,
      ),
    );
  }
}
