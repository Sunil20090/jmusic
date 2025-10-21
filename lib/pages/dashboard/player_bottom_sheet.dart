import 'package:flutter/material.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/constants/image_constant.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:just_audio/just_audio.dart';

class PlayerBottomSheet extends StatefulWidget {
  SongModal song;
  AudioPlayer audioPlayer;
  PlayerBottomSheet({super.key, required this.song, required this.audioPlayer});

  @override
  State<PlayerBottomSheet> createState() => _PlayerBottomSheetState();
}

class _PlayerBottomSheetState extends State<PlayerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ICON_APP, width: 48, height: 48),
          addHorizontalSpace(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.song.title, style: getTextTheme().titleMedium),
              Text(widget.song.artist, style: getTextTheme().bodyMedium),
            ],
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

          addHorizontalSpace(8),
        ],
      ),
    );
  }
}
