import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/components/custom/song_card.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/pages/dashboard/player_bottom_sheet.dart';
import 'package:jmusic/pages/dashboard/search_song_screen.dart';
import 'package:jmusic/pages/player_screen.dart';
import 'package:jmusic/pages/upload_song_screen.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:jmusic/utils/user/user_service.dart';
import 'package:just_audio/just_audio.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var _songMasterList = [];

  bool fetchingSongs = false;

  SongModal? _currentSong;

  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _initPlayer();
    initSongList();
  }

  _initPlayer() async {
    _player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  playSong(song) async {
    try {
      await _player.setUrl(song.song_url);

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

  void initSongList() async {
    setState(() {
      fetchingSongs = true;
    });

    var userId = await getUserId();
    var body = {"userId": userId};

    ApiResponse response = await postService(URL_SONG_LIST, body);

    setState(() {
      fetchingSongs = false;
    });
    if (response.isSuccess) {
      setState(() {
        _songMasterList = groupByAlbum(response.body);
      });
    }
  }

  groupByAlbum(List<dynamic> song_list) {
    int counter = 0;

    var master_list = [];
    for (var song in song_list) {
      var foundIndex = master_list.any(
        (element) => element['album'] == song['album'],
      );
      if (!foundIndex) {
        master_list.add({'album': song['album']});
        master_list[master_list.length - 1]['songs'] = song_list
            .where((element) => element['album'] == song['album'])
            .toList();
        counter++;
      }
    }

    return master_list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: SCREEN_PADDING,
              child: (!fetchingSongs)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Songs',
                              style: getTextTheme(
                                color: COLOR_PRIMARY,
                              ).headlineLarge,
                            ),
                            Spacer(),
                            IconButton(
                              color: COLOR_PRIMARY,
                              onPressed: () {
                                openUploadSongScreen();
                              },
                              icon: Icon(Icons.upload, size: 32),
                            ),
                            IconButton(
                              color: COLOR_PRIMARY,
                              onPressed: () {
                                openSearhSongScreen();
                              },
                              icon: Icon(Icons.search, size: 32),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _songMasterList.length,
                            itemBuilder: (context, index) {
                              var songList = [];
                              songList = _songMasterList[index]['songs'];
                              return Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 24,
                                        left: 8,
                                      ),
                                      child: Text(
                                        _songMasterList[index]['album'],
                                        style: getTextTheme(
                                          color: COLOR_SECONDARY,
                                        ).titleLarge,
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        spacing: 14,
                                        children: songList.map((elem) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                _currentSong =
                                                    SongModal.fromJson(elem);
                                                playSong(_currentSong);
                                              });
                                            },
                                            child: SongCard(
                                              title: elem['title'],
                                              imageUrl: elem['thumbnail'],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    addVerticalSpace(),
                                    Divider(height: 2, thickness: 0.4),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        addVerticalSpace(DEFAULT_LARGE_SPACE),
                        ProgressCircular(
                          color: COLOR_BLACK,
                          width: 42,
                          height: 42,
                        ),
                      ],
                    ),
            ),

            if (_currentSong != null)
              Positioned(
                bottom: 4,
                right: 4,
                left: 4,
                child: PlayerBottomSheet(
                  song: _currentSong!,
                  audioPlayer: _player,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void openPlayerScreen(SongModal song) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => PlayerScreen(song: song)),
    );
  }

  void openUploadSongScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => UploadSongScreen()),
    );
  }

  void openSearhSongScreen() async {
    SongModal? song = await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => SearchSongScreen()),
    );
    if (song != null) {
      openPlayerScreen(song);
    }
  }
}
