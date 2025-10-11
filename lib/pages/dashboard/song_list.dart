import 'package:flutter/material.dart';
import 'package:jmusic/components/custom/song_card.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/pages/player_screen.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var _songMasterList = [];
  @override
  void initState() {
    super.initState();

    initSongList();
  }

  void initSongList() async {
    ApiResponse response = await postService(URL_SONG_LIST, {});
    if (response.isSuccess) {
      setState(() {
        _songMasterList = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: CONTENT_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(DEFAULT_LARGE_SPACE),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Songs',
                style: getTextTheme(color: COLOR_PRIMARY).headlineMedium,
              ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            _songMasterList[index]['heading'],
                            style: getTextTheme(color: COLOR_GREY).titleSmall,
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
                                child: Hero(
                                  tag: elem['image_url'],
                                  child: SongCard(
                                    title: elem['title'],
                                    imageUrl: elem['image_url'],
                                  ),
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
        ),
      ),
    );
  }

  void openPlayerScreen(elem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => PlayerScreen(music: elem)),
    );
  }
}
