import 'package:flutter/material.dart';
import 'package:jmusic/components/profile_thumbnail.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/pages/player_screen.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:jmusic/utils/settings/setting_utils.dart';
import 'package:jmusic/utils/user/user_service.dart';
import 'package:just_audio/just_audio.dart';

class PlayerBottomSheet extends StatefulWidget {
  SongModal song;
  AudioPlayer audioPlayer;
  Function(SongModal song) playSongMethod;
  PlayerBottomSheet({
    super.key,
    required this.song,
    required this.audioPlayer,
    required this.playSongMethod
  });

  @override
  State<PlayerBottomSheet> createState() => _PlayerBottomSheetState();
}

class _PlayerBottomSheetState extends State<PlayerBottomSheet> {
  bool _fetchingNextSong = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.processingStateStream.listen((processState) {
      if (processState == ProcessingState.completed) {
        if (SettingUtils.repeatType == SettingUtils.REPEAT_ALL) {
          playNextSong();
        } else if (SettingUtils.repeatType == SettingUtils.REPEAT_ONE) {
          restartSong();
        }
      }
    });
  }

  restartSong() {
    widget.audioPlayer.seek(Duration.zero);
    widget.audioPlayer.play();
  }

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
                  Text(
                    widget.song.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getTextTheme().titleMedium,
                  ),
                  Text(
                    widget.song.artist,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getTextTheme().bodyMedium,
                  ),
                ],
              ),
            ),
            // Spacer(),
            StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final isPlaying = playerState?.playing;
                if (processingState == ProcessingState.buffering ||
                    processingState == ProcessingState.loading) {
                  return ProgressCircular(color: COLOR_BLACK);
                } else if (isPlaying != true) {
                  return InkWell(
                    onTap: () => widget.audioPlayer.play(),
                    child: Icon(Icons.play_arrow),
                  );
                } else if (processingState == ProcessingState.completed) {
                  return InkWell(
                    onTap: () {
                      widget.audioPlayer.seek(Duration(seconds: 0));
                      widget.audioPlayer.play();
                    },
                    child: Icon(Icons.replay_outlined),
                  );
                } else {
                  return InkWell(
                    onTap: () => widget.audioPlayer.pause(),
                    child: Icon(Icons.pause_outlined),
                  );
                }
              },
            ),
    
            IconButton(
              onPressed: () {
                playNextSong();
              },
              icon: (!_fetchingNextSong)
                  ? Icon(Icons.skip_next)
                  : ProgressCircular(color: COLOR_BLACK),
            ),
    
            addHorizontalSpace(8),
          ],
        ),
      ),
    );
  }

  void playNextSong() async {
    var body = {"current_song_id": widget.song.id, "userId": await getUserId()};

    setState(() {
      _fetchingNextSong = true;
    });
    ApiResponse response = await postService(URL_NEXT_SONG, body);

    setState(() {
      _fetchingNextSong = false;
    });

    if (response.isSuccess) {
      widget.song = SongModal.fromJson(response.body[0]);
      setState(() {
        widget.audioPlayer.dispose();
        widget.playSongMethod(widget.song);
      });
    }
  }

  
}
