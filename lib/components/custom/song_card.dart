import 'package:flutter/material.dart';
import 'package:jmusic/components/rounded_rect_image.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';

class SongCard extends StatelessWidget {
  String title;
  String? imageUrl;
  SongCard({super.key, required this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          child: RoundedRectImage(
            width: 150,
            height: 150,
            thumbnail_url: imageUrl,
          ),
        ),
        addVerticalSpace(2),
        Row(
          children: [
            addHorizontalSpace(),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              
              style: getTextTheme().bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
