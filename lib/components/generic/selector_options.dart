import 'package:flutter/material.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';

class SelectorOptions extends StatelessWidget {
  List<String> list;
  Function(String selectedItem)? onItemSelected;
  SelectorOptions({super.key, required this.list, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...list.map((item) {
          return ListTile(
            onTap: () {
              if (onItemSelected != null) {
                onItemSelected!(item);
              }
            },
            title: Row(
              children: [
                addHorizontalSpace(),
                Text(item, style: getTextTheme().titleLarge,),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

}

