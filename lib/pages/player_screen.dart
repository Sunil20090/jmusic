import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/components/rounded_rect_image.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:jmusic/utils/music_handler.dart';
import 'package:jmusic/utils/user/user_service.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  // String? thumbnailUrl;
  // String songUrl, title, artist;
  // int song_id;

  SongModal song;

  PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  var _relatedSongs = [];

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _initMusicList();
  }

  _initMusicList() async {
    var body = {"referenceSongId": widget.song.id, "userId": await getUserId()};
    ApiResponse response = await postService(URL_RELATED_SONGS, body);

    if (response.isSuccess) {
      _relatedSongs = response.body;
      setState(() {});
    }
  }

  _initPlayer() async {
    if (MusicHandler.audioPlayer != null) {
      MusicHandler.audioPlayer!.dispose();
    }
    MusicHandler.audioPlayer = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    try {
      await MusicHandler.audioPlayer!.setUrl(widget.song.song_url);

      await MusicHandler.play();

      setState(() {});
    } catch (e) {
      // print("error : $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: SingleChildScrollView(
            child: Column(
              children: [
                addVerticalSpace(DEFAULT_LARGE_SPACE),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 4,
                    child: RoundedRectImage(
                      width: 200,
                      height: 200,
                      thumbnail_url: widget.song.thumbnail,
                    ),
                  ),
                ),

                Text(
                  widget.song.title,
                  style: getTextTheme(color: COLOR_PRIMARY).headlineMedium,
                ),
                Text(
                  'By: ${widget.song.artist}',
                  style: getTextTheme(color: COLOR_SECONDARY).titleSmall,
                ),
                addVerticalSpace(),
                Column(
                  children: [
                    StreamBuilder<Duration?>(
                      stream: MusicHandler.audioPlayer!.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data;
                        return StreamBuilder<Duration>(
                          stream: MusicHandler.audioPlayer!.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data;

                            return StreamBuilder<Duration?>(
                              stream: MusicHandler
                                  .audioPlayer!
                                  .bufferedPositionStream,
                              builder: (context, snapshot) {
                                final bufferedPosition = snapshot.data;
                                if (position == null ||
                                    duration == null ||
                                    bufferedPosition == null) {
                                  return Container();
                                } else {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          addHorizontalSpace(20),
                                          Text(
                                            formatDurationInMinutes(position),
                                          ),
                                          Spacer(),
                                          Text(
                                            formatDurationInMinutes(duration),
                                          ),
                                          addHorizontalSpace(20),
                                        ],
                                      ),

                                      Stack(
                                        children: [
                                          SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                                  thumbShape:
                                                      SliderComponentShape
                                                          .noThumb,
                                                  activeTrackColor:
                                                      COLOR_SECONDARY,
                                                  inactiveTrackColor:
                                                      COLOR_SECONDARY,
                                                ),
                                            child: Slider(
                                              min: 0.0,
                                              max: 1.0,
                                              secondaryActiveColor:
                                                  COLOR_PRIMARY,
                                              activeColor: COLOR_SECONDARY,
                                              value:
                                                  bufferedPosition.inSeconds /
                                                  duration.inSeconds,
                                              onChanged: null,
                                            ),
                                          ),
                                          Slider(
                                            min: 0.0,
                                            max: 1.0,

                                            activeColor: COLOR_PRIMARY,
                                            value:
                                                position.inSeconds /
                                                duration.inSeconds,
                                            onChanged: (value) {
                                              MusicHandler.audioPlayer!.seek(
                                                Duration(
                                                  seconds:
                                                      (duration.inSeconds *
                                                              value)
                                                          .toInt(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 48,
                          onPressed: () {},
                          icon: Icon(Icons.skip_previous),
                        ),
                        addHorizontalSpace(),
                        StreamBuilder<PlayerState>(
                          stream: MusicHandler.audioPlayer!.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final playing = playerState?.playing;

                            final processingState =
                                playerState?.processingState;

                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return CircularProgressIndicator();
                            } else if (playing != true) {
                              return IconButton(
                                iconSize: 64,
                                onPressed: () {
                                  MusicHandler.play();
                                },
                                icon: Icon(Icons.play_arrow),
                              );
                            } else if (processingState ==
                                ProcessingState.completed) {
                              return IconButton(
                                iconSize: 64,
                                onPressed: () async {
                                  await MusicHandler.audioPlayer!.seek(Duration.zero);
                                  await MusicHandler.play();
                                },
                                icon: Icon(
                                  Icons.replay_circle_filled,
                                  color: COLOR_PRIMARY,
                                ),
                              );
                            } else {
                              return IconButton(
                                iconSize: 64,
                                onPressed: () {
                                   MusicHandler.pause();
                                },
                                icon: Icon(Icons.pause_circle),
                              );
                            }
                          },
                        ),
                        addHorizontalSpace(),
                        IconButton(
                          iconSize: 48,
                          onPressed: () {},
                          icon: Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(),
                ..._relatedSongs.map((relatedSong) {
                  return ListTile(
                    onTap: () {
                      playSong(relatedSong);
                    },
                    title: Row(
                      children: [
                        RoundedRectImage(
                          width: 40,
                          height: 40,
                          thumbnail_url: relatedSong['thumbnail'],
                        ),
                        addHorizontalSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relatedSong['title'],
                              style: getTextTheme().titleSmall,
                            ),
                            //addVerticalSpace(),
                            Text(
                              relatedSong['artist'],
                              style: getTextTheme().bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void playSong(relatedSong) async {
    widget.song.song_url = relatedSong['song_url'];
    widget.song.id = relatedSong['id'];
    widget.song.title = relatedSong['title'];
    widget.song.thumbnail = relatedSong['thumbnail'];
    setState(() {});
    MusicHandler.dispose();
    await _initPlayer();
  }
}
