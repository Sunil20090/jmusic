import 'package:jmusic/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class PropertyView extends StatelessWidget {
  final String property, value;
  PropertyView({super.key, required this.property, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${property} ', style: getTextTheme().bodyMedium),
        Text(value, style: getTextTheme().headlineSmall),
      ],
    );
  }
}
