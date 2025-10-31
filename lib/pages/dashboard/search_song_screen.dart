import 'package:flutter/material.dart';
import 'package:jmusic/components/floating_label_edit_box.dart';
import 'package:jmusic/components/rounded_rect_image.dart';
import 'package:jmusic/constants/local_constant.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/song_modal.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:jmusic/utils/user/user_service.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({super.key});

  @override
  State<SearchSongScreen> createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  var _filteredItems = [];
  var isCalling = false;
  var _lastQuery = null;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
    _filterList();

    screenRecord(screen: 'search', event_name: 'screen_open');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: COLOR_PRIMARY,
          title: Text(
            'Search',
            style: getTextTheme(color: COLOR_PRIMARY).headlineLarge,
          ),
        ),
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingLabelEditBox(
                  labelText: "Search...",
                  controller: _searchController,
                ),
              ),

              ..._filteredItems.map((song) {
                return ListTile(
                  onTap: () {
                    final choosen_song = SongModal.fromJson(song);
                    screenRecord(screen: 'search', event_name: 'song_clicked');
                    Navigator.pop(context, choosen_song);
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedRectImage(
                        thumbnail_url: song['thumbnail'],
                        width: 40,
                        height: 40,
                      ),
                      addHorizontalSpace(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${song['title']}',
                            style: getTextTheme().titleMedium,
                          ),
                          Text(
                            '${song['artist']}',
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
    );
  }

  void _filterList() async {
    final query = _searchController.text.toLowerCase();

    if (isCalling || _lastQuery == query) {
      return;
    }

    isCalling = true;

    Future.delayed(Duration(seconds: SEARCH_TIME_SECONDS), () {
      isCalling = false;

      _filterList();
    });

    var body = {"query": query, 'userId': await getUserId()};
    _lastQuery = query;
    postService(URL_SONG_QUERY, body).then((response) {
      if (response.isSuccess) {
        setState(() {
          _filteredItems = response.body;
        });
      }
    });
  }
}
