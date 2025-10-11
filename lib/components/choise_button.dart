import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:flutter/material.dart';

class ChoiseButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDeleteClicked;

  ChoiseButton({super.key, required this.child, this.onDeleteClicked});

  @override
  State<ChoiseButton> createState() => _ChoiseButtonState();
}

class _ChoiseButtonState extends State<ChoiseButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: SCREEN_PADDING,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 110, 110, 110),
      ),
      child: Row(
        children: [
          widget.child,
          addHorizontalSpace(),
          InkWell(
            onTap: widget.onDeleteClicked,
            child: Icon(
              Icons.delete,
              color: COLOR_WHITE,
              size: getTextTheme().titleMedium?.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
