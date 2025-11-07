import 'package:flutter/material.dart';
import 'package:jmusic/components/generic/selector_options.dart';
import 'package:jmusic/constants/theme_constant.dart';

class SelectorScreen extends StatelessWidget {
  final String title;
  final List<String> list;
  const SelectorScreen({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: getTextTheme(color: COLOR_PRIMARY).headlineLarge,
          ),
          foregroundColor: COLOR_PRIMARY,
        ),
        body: SingleChildScrollView(
          child: SelectorOptions(
            list: list,
            onItemSelected: (selectedItem) {
              Navigator.pop(context, selectedItem);
            },
          ),
        ),
      ),
    );
  }
}
