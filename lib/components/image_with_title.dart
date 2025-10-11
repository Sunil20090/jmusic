import 'package:jmusic/components/profile_thumbnail.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:flutter/material.dart';

class ImageWithTitle extends StatelessWidget {
  final Widget container;
  final String? avatarUrl, avatarThumbnailUrl;
  final String title, description, tag, timeStamp;
  final int solutionCount = 0, ideaCount = 0;
  final VoidCallback? onImagePressed, onAvatarPressed, onInfoPressed;

  const ImageWithTitle({
    super.key,
    required this.container,
    required this.avatarUrl,
    required this.avatarThumbnailUrl,
    required this.title,
    required this.description,
    required this.timeStamp,
    this.onImagePressed,
    this.onAvatarPressed,
    this.tag = 'image_with_title',
    this.onInfoPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onImagePressed,
            child: Container(
              color: COLOR_BASE_DARKER,
              height: UI_IMAGE_HEIGHT,
              width: double.infinity,
              child: Hero(child: container, tag: tag),
            ),
          ),
          addVerticalSpace(4),
          Row(
            children: [
              addHorizontalSpace(),
              InkWell(
                onTap: onAvatarPressed,
                child: ProfileThumbnail(
                  radius: 20,
                  width: 40,
                  height: 40,
                  thumnail_url: avatarThumbnailUrl,
                ),
              ),
              addHorizontalSpace(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: getTextTheme().titleSmall),
                    Text(
                      description,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(timeStamp, style: getTextTheme().bodySmall),
                  ],
                ),
              ),
              InkWell(onTap: onInfoPressed, child: Icon(Icons.info)),
              addHorizontalSpace(),
            ],
          ),
        ],
      ),
    );
  }
}
