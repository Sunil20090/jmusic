import 'dart:io';

import 'package:jmusic/constants/image_constant.dart';
import 'package:flutter/material.dart';

class ProfileThumbnail extends StatefulWidget {
  final String? imageUrl, thumnail_url;
  final File? file;
  final double radius, width, height;
  String? tag;
  VoidCallback? onClicked;
  ProfileThumbnail({
    super.key,
    this.imageUrl,
    this.thumnail_url,
    this.file,
    this.tag = 'image_tag',
    this.onClicked,
    this.radius = 25,
    this.width = 50,
    this.height = 50,
  });

  @override
  State<ProfileThumbnail> createState() => _ProfileThumbnailState();
}

class _ProfileThumbnailState extends State<ProfileThumbnail> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClicked,
      child: Hero(
        tag: widget.tag!,
        child: CircleAvatar(
          radius: widget.radius,
          child: ClipOval(
            child: widget.imageUrl == null && widget.thumnail_url == null
                ? (widget.file == null)
                      ? Image.asset(
                          IMAGE_PROFILE,
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          widget.file!,
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.cover,
                        )
                : (widget.imageUrl != null && widget.thumnail_url != null)
                ? FadeInImage(
                    placeholder: Image.network(
                      width: widget.width,
                      height: widget.height,
                      fit: BoxFit.cover,
                      widget.thumnail_url!,
                    ).image,
                    image: Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                    ).image,
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.thumnail_url!,
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
