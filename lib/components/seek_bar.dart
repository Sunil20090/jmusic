
import 'package:flutter/material.dart';
import 'package:jmusic/constants/theme_constant.dart';

class SeekBar extends StatefulWidget {
  double width, value;

  SeekBar({super.key, required this.width, required this.value});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLOR_BASE,

      height: 10,
      alignment: Alignment.center,
      child: Container(color: COLOR_PRIMARY, height: 8, width: widget.width * widget.value)
    );
  }
}
