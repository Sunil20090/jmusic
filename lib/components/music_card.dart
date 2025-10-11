import 'package:flutter/material.dart';
import 'package:jmusic/components/rounded_rect_image.dart';

class MusicCard extends StatefulWidget {
  final String url;
  const MusicCard({super.key, required this.url});

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: RoundedRectImage(
        width: 300,
        height: 300,
        thumbnail_url: widget.url),
    );
  }
}