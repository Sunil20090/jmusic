import 'package:jmusic/constants/image_constant.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class RoundedRectImage extends StatefulWidget {
  final double width, height;
  final String? thumbnail_url;
  final String? image_url;
  String offlineImageSrc;
  RoundedRectImage({
    super.key,
    this.width = 80,
    this.height = 50,
    this.image_url,
    this.thumbnail_url,
    this.offlineImageSrc = PLACEHOLDER_IMAGE_MUSIC
  });
  @override
  State<RoundedRectImage> createState() => _RoundedRectImageState();
}

class _RoundedRectImageState extends State<RoundedRectImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: COLOR_BASE_DARKER, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: (widget.image_url != null && widget.thumbnail_url != null)
              ? FadeInImage(
                  placeholder: Image.network(widget.thumbnail_url!).image,
                  image: Image.network(widget.image_url!).image,
                  fit: BoxFit.cover,
                )
              : (widget.thumbnail_url != null) 
              ? FadeInImage(
                  placeholder: Image.asset(widget.offlineImageSrc).image,
                  image: Image.network(widget.thumbnail_url!).image,
                  fit: BoxFit.cover,
                )
                : Image.asset(widget.offlineImageSrc, fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
