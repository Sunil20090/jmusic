import 'package:flutter/material.dart';
import 'package:jmusic/components/profile_thumbnail.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:just_audio/just_audio.dart';

class PlayerBottomSheet extends StatefulWidget {
  SongModal song;
  AudioPlayer audioPlayer;
  Function onNextClicked;
  bool fetchingNext;
  PlayerBottomSheet({
    super.key,
    required this.song,
    required this.audioPlayer,
    required this.onNextClicked,
    required this.fetchingNext
  });

  @override
  State<PlayerBottomSheet> createState() => _PlayerBottomSheetState();
}

class _PlayerBottomSheetState extends State<PlayerBottomSheet> {
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: CONTENT_PADDING,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(ICON_APP, width: 48, height: 48),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: COLOR_BASE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ProfileThumbnail(
                thumnail_url: widget.song.thumbnail,
                width: 48,
                height: 48,
                radius: 24,
              ),
            ),
            addHorizontalSpace(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.song.title, overflow: TextOverflow.ellipsis, maxLines: 1, style: getTextTheme().titleMedium),
                  Text(widget.song.artist, overflow: TextOverflow.ellipsis, maxLines: 1, style: getTextTheme().bodyMedium),
                  
                ],
              ),
            ),
            Spacer(),
            StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState!.processingState;
                final isPlaying = playerState.playing;
                if (processingState == ProcessingState.buffering ||
                    processingState == ProcessingState.loading) {
                  return ProgressCircular(color: COLOR_BLACK);
                } else if (isPlaying != true) {
                  return IconButton(
                    onPressed: () {
                      widget.audioPlayer.play();
                    },
                    icon: Icon(Icons.play_arrow_outlined),
                  );
                } else if (processingState == ProcessingState.completed) {
                  return IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.replay_outlined),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      widget.audioPlayer.pause();
                    },
                    icon: Icon(Icons.pause_outlined),
                  );
                }
              },
            ),

            IconButton(
              onPressed: () {
                widget.fetchingNext = true;
                widget.onNextClicked();
              },
              icon: (!widget.fetchingNext)
                  ? Icon(Icons.skip_next)
                  : ProgressCircular(color: COLOR_BLACK),
            ),

            addHorizontalSpace(8),
          ],
        ),
      ),
    );
  }
}
