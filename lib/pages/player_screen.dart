import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/components/rounded_rect_image.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  String? thumbnailUrl;
  String songUrl, title;

  PlayerScreen({super.key, required this.title, required this.songUrl, this.thumbnailUrl});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  _initPlayer() async {
    _player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    try {
      await _player.setUrl(widget.songUrl);

      await _player.play();

      setState(() {});
    } catch (e) {
      // print("error : $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: CONTENT_PADDING,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  child: RoundedRectImage(
                    width: double.infinity,
                    height: 300,
                    thumbnail_url: widget.thumbnailUrl,
                  ),
                ),
              ),

              Text(
                widget.title,
                style: getTextTheme(color: COLOR_PRIMARY).headlineMedium,
              ),
              addVerticalSpace(),
              Column(
                children: [
                  StreamBuilder<Duration?>(
                    stream: _player.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data;
                      return StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data;

                          return StreamBuilder<Duration?>(
                            stream: _player.bufferedPositionStream,
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
                                                thumbShape: SliderComponentShape
                                                    .noThumb,
                                                activeTrackColor:
                                                    COLOR_SECONDARY,
                                                inactiveTrackColor:
                                                    COLOR_SECONDARY,
                                              ),
                                          child: Slider(
                                            min: 0.0,
                                            max: 1.0,
                                            secondaryActiveColor: COLOR_PRIMARY,
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
                                            _player.seek(
                                              Duration(
                                                seconds:
                                                    (duration.inSeconds * value)
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
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;

                          final processingState = playerState?.processingState;

                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return CircularProgressIndicator();
                          } else if (playing != true) {
                            return IconButton(
                              iconSize: 64,
                              onPressed: () {
                                _player.play();
                              },
                              icon: Icon(Icons.play_arrow),
                            );
                          } else if (processingState ==
                              ProcessingState.completed) {
                            return IconButton(
                              iconSize: 64,
                              onPressed: () async {
                                await _player.seek(Duration.zero);
                                await _player.play();
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
                                _player.pause();
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
            ],
          ),
        ),
      ),
    );
  }
}
