import 'package:flutter/material.dart';
import 'package:jmusic/components/custom/song_card.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/pages/dashboard/search_song_screen.dart';
import 'package:jmusic/pages/player_screen.dart';
import 'package:jmusic/pages/upload_song_screen.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var _songMasterList = [];

  bool fetchingSongs = false;

  @override
  void initState() {
    super.initState();

    initSongList();
  }

  void initSongList() async {
    setState(() {
      fetchingSongs = true;
    });
    ApiResponse response = await postService(URL_SONG_LIST, {});

    setState(() {
      fetchingSongs = false;
    });
    if (response.isSuccess) {
      setState(() {
        print(groupByAlbum(response.body));
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
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: (!fetchingSongs)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Songs',
                          style: getTextTheme(
                            color: COLOR_PRIMARY,
                          ).headlineLarge,
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
                                addVerticalSpace(DEFAULT_LARGE_SPACE),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    _songMasterList[index]['album'],
                                    style: getTextTheme(
                                      color: COLOR_GREY,
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
                                          openPlayerScreen(elem);
                                        },
                                        child: SongCard(
                                          title: elem['title'],
                                          imageUrl: elem['thumbnail'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
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
                  children: [ProgressCircular()],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openUploadSongScreen();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void openPlayerScreen(elem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => PlayerScreen(
          song_id: elem['id'],
          songUrl: elem['song_url'],
          thumbnailUrl: elem['thumbnail'],
          title: elem['title'],
          artist: elem['artist'],
        ),
      ),
    );
  }

  void openUploadSongScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => UploadSongScreen()),
    );
  }

  void openSearhSongScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => SearchSongScreen()),
    );
  }
}
