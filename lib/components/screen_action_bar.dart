import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenActionBar extends StatelessWidget {
  final String title;
  final Widget? child;
  bool backButtonEnabled;
  ScreenActionBar({
    super.key,
    required this.title,
    this.child,
    this.backButtonEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: CONTENT_PADDING_VALUE,
          right: CONTENT_PADDING_VALUE,
          top: CONTENT_PADDING_VALUE,
        ),
      child: 
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (backButtonEnabled)
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: COLOR_PRIMARY,
                          size: getTextTheme().headlineMedium?.fontSize,
                        ),
                      ),
                      addHorizontalSpace(),
                    ],
                  ),
                Text(
                  title,
                  style: getTextTheme(color: COLOR_PRIMARY).headlineMedium,
                ),
                Spacer(),
                Container(child: child),
              ],
            ),
          ],
        ),
    );
  }
}
