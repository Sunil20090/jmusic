import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jmusic/components/generic/round_rect.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/components/rounded_rect_image.dart';
import 'package:jmusic/constants/image_constant.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:jmusic/utils/settings/setting_utils.dart';
import 'package:jmusic/utils/user/user_service.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  SongModal song;
  AudioPlayer audioPlayer;

  Function(SongModal song) onSongSelected;

  PlayerScreen({
    super.key,
    required this.song,
    required this.audioPlayer,
    required this.onSongSelected,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  var _relatedSongs = [];

  @override
  void initState() {
    super.initState();

    print('is favi  ${widget.song.isFavourite}');
    _initRelatedMusicList();

    screenRecord(
      screen: 'player_screen',
      ref_id: widget.song.id,
      event_name: 'screen_open',
    );
    widget.audioPlayer.processingStateStream.listen((processState) {
      if (processState == ProcessingState.completed) {
        if (SettingUtils.repeatType == SettingUtils.REPEAT_ONE) {
          restartSong();
          return;
        }

        if (SettingUtils.repeatType == SettingUtils.REPEAT_ALL) {
          playNextSong();
          return;
        }
      }
    });
  }

  restartSong() {
    widget.audioPlayer.seek(Duration.zero);
    widget.audioPlayer.play();
  }

  _initRelatedMusicList() async {
    var body = {"referenceSongId": widget.song.id, "userId": await getUserId()};
    ApiResponse response = await postService(URL_RELATED_SONGS, body);

    if (response.isSuccess) {
      setState(() {
        _relatedSongs = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              addVerticalSpace(),
              Row(
                children: [
                  RoundRect(
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: FadeInImage(
                        placeholder: Image.asset(
                          PLACEHOLDER_IMAGE_MUSIC,
                          fit: BoxFit.fill,
                        ).image,
                        image: Image.network(
                          widget.song.thumbnail!,
                          fit: BoxFit.fill,
                        ).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      child:
                          //Container()
                          RoundedRectImage(
                            width: 200,
                            height: 200,

                            thumbnail_url: widget.song.thumbnail,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundRect(
                    child: IconButton(
                      iconSize: 32,
                      onPressed: () {
                        addToFavorite();
                      },
                      icon: (widget.song.isFavourite)
                          ? Icon(Icons.favorite, color: Colors.redAccent)
                          : Icon(Icons.favorite),
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.song.title,
                        style: getTextTheme(
                          color: COLOR_PRIMARY,
                        ).headlineMedium,
                      ),
                      Text(
                        'By: ${widget.song.artist}',
                        style: getTextTheme(color: COLOR_SECONDARY).titleSmall,
                      ),
                    ],
                  ),
                  Spacer(),

                  RoundRect(
                    child: IconButton(
                      iconSize: 32,
                      onPressed: () {
                        //addToFavorite();
                      },
                      icon: Icon(Icons.playlist_add),
                    ),
                  ),
                ],
              ),

              addVerticalSpace(),
              Column(
                children: [
                  StreamBuilder<Duration?>(
                    stream: widget.audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data;
                      return StreamBuilder<Duration>(
                        stream: widget.audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data;

                          return StreamBuilder<Duration?>(
                            stream: widget.audioPlayer.bufferedPositionStream,
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
                                        Text(formatDurationInMinutes(position)),
                                        Spacer(),
                                        Text(formatDurationInMinutes(duration)),
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
                                            widget.audioPlayer.seek(
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
                        iconSize: 32,
                        onPressed: () {
                          setState(() {
                            SettingUtils.toggleSuffle();
                          });
                        },
                        icon:
                            (SettingUtils.suffleType == SettingUtils.SUFFLE_ON)
                            ? Icon(Icons.shuffle, color: COLOR_PRIMARY)
                            : Icon(Icons.shuffle),
                      ),

                      IconButton(
                        iconSize: 48,
                        onPressed: () {
                          playNextSong(delta: -1);
                        },
                        icon: Icon(Icons.skip_previous),
                      ),
                      addHorizontalSpace(),
                      StreamBuilder<PlayerState>(
                        stream: widget.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;

                          final processingState = playerState?.processingState;

                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return ProgressCircular(
                              color: COLOR_BLACK,
                              width: 45,
                              height: 45,
                            );
                          } else if (playing != true) {
                            return IconButton(
                              iconSize: 64,
                              onPressed: () {
                                setState(() {
                                  widget.audioPlayer.play();
                                });
                              },
                              icon: Icon(
                                Icons.play_circle_fill,
                                color: COLOR_PRIMARY,
                              ),
                            );
                          } else if (processingState ==
                              ProcessingState.completed) {
                            return IconButton(
                              iconSize: 64,
                              onPressed: () async {
                                setState(() {
                                  widget.audioPlayer.seek(Duration.zero);
                                  widget.audioPlayer.play();
                                });
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
                                setState(() {
                                  widget.audioPlayer.pause();
                                });
                              },
                              icon: Icon(
                                Icons.pause_circle_filled,
                                color: COLOR_PRIMARY,
                              ),
                            );
                          }
                        },
                      ),
                      addHorizontalSpace(),
                      IconButton(
                        iconSize: 48,
                        onPressed: () {
                          playNextSong();
                        },
                        icon: Icon(Icons.skip_next),
                      ),

                      IconButton(
                        iconSize: 32,
                        onPressed: () {
                          setState(() {
                            SettingUtils.toggleRepeat();
                          });
                        },
                        icon:
                            (SettingUtils.repeatType == SettingUtils.REPEAT_ONE)
                            ? Icon(Icons.repeat_one, color: COLOR_PRIMARY)
                            : (SettingUtils.repeatType ==
                                  SettingUtils.REPEAT_ALL)
                            ? Icon(Icons.repeat_on, color: COLOR_PRIMARY)
                            : Icon(Icons.repeat),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(),
              Row(
                children: [
                  Icon(Icons.playlist_add),
                  addHorizontalSpace(),
                  Text(
                    'Playlist (Related Songs)',
                    style: getTextTheme().titleLarge,
                  ),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: _relatedSongs.length,
                  itemBuilder: (context, index) {
                    final relatedSong = _relatedSongs[index];
                    return ListTile(
                      onTap: () {
                        if (widget.song.id != relatedSong['id']) {
                          setState(() {
                            widget.song = SongModal.fromJson(relatedSong);
                            widget.onSongSelected(widget.song);
                          });
                          playSong();
                        }
                      },
                      title: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              RoundedRectImage(
                                width: 40,
                                height: 40,
                                thumbnail_url: relatedSong['thumbnail'],
                              ),

                              if (relatedSong['isFavourite'] == 1)
                                Positioned(
                                  left: -4,
                                  bottom: -4,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          addHorizontalSpace(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                relatedSong['title'],
                                style: getTextTheme(
                                  color: (relatedSong['id'] == widget.song.id)
                                      ? COLOR_PRIMARY
                                      : COLOR_BLACK,
                                ).titleMedium,
                              ),
                              //addVerticalSpace(),
                              Text(
                                relatedSong['artist'],
                                style: getTextTheme(
                                  color: (relatedSong['id'] == widget.song.id)
                                      ? COLOR_PRIMARY
                                      : COLOR_BLACK,
                                ).bodySmall,
                              ),
                            ],
                          ),

                          Spacer(),

                          if (relatedSong['id'] == widget.song.id)
                            (!widget.audioPlayer.playing)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.audioPlayer.play();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: COLOR_PRIMARY,
                                      size: 34,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.audioPlayer.pause();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.pause,
                                      color: COLOR_PRIMARY,
                                      size: 34,
                                    ),
                                  ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  playSong() async {
    try {
      widget.audioPlayer.setUrl(widget.song.song_url);

      widget.audioPlayer.play();
    } catch (e) {
      // print("error : $e");
    }
  }

  void addToFavorite() async {
    setState(() {
      final searchedSong = _relatedSongs.firstWhere(
        (song) => song['id'] == widget.song.id,
      );

      if (widget.song.isFavourite) {
        widget.song.isFavourite = false;
      } else {
        widget.song.isFavourite = true;
      }
      searchedSong['isFavourite'] = widget.song.isFavourite ? 1 : 0;
    });

    var body = {"userId": await getUserId(), "songId": widget.song.id};

    ApiResponse response = await postService(URL_ADD_TO_FAVOURITE, body);

    if (response.isSuccess) {
      print(response.body);
    }
  }

  void playNextSong({int delta = 1}) async {
    final random = Random();
    var nextSong;

    if (SettingUtils.suffleType == SettingUtils.SUFFLE_ON) {
      nextSong = _relatedSongs[random.nextInt(_relatedSongs.length)];
    } else if (SettingUtils.suffleType == SettingUtils.SUFFLE_OFF) {
      int index = _relatedSongs.indexWhere((el) => el['id'] == widget.song.id);

      int nextIndex = (index + delta) % _relatedSongs.length;
      nextSong = _relatedSongs[nextIndex];
      print('next index $nextIndex');
    }

    setState(() {
      widget.song = SongModal.fromJson(nextSong);
      widget.onSongSelected(widget.song);
    });

    playSong();
  }
}
