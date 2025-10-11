import 'package:flutter/material.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';

class MusicAction extends StatefulWidget {
  String soundUrl;
  MusicAction({super.key, required this.soundUrl});

  @override
  State<MusicAction> createState() => _MusicActionState();
}

class _MusicActionState extends State<MusicAction> {
  double _startPosition = 0.0;
  double _currentPosis = 0.0;
  double _endPosition = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CONTENT_PADDING,
      child: Column(
        children: [
          addVerticalSpace(DEFAULT_LARGE_SPACE),
          Row(
            children: [
              addHorizontalSpace(),
              Icon(Icons.favorite, color: COLOR_RED),
              Spacer(),
              Icon(Icons.download_outlined, color: COLOR_GREY),
              addHorizontalSpace(),
            ],
          ),
          addVerticalSpace(DEFAULT_LARGE_SPACE),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.skip_previous, color: COLOR_GREY, size: 30),
              addHorizontalSpace(),
              Icon(Icons.play_circle, color: COLOR_PRIMARY, size: 50),
              addHorizontalSpace(),
              Icon(Icons.skip_next, color: COLOR_GREY, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
