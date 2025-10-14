import 'package:flutter/material.dart';
import 'package:jmusic/components/floating_label_edit_box.dart';
import 'package:jmusic/constants/local_constant.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
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

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search', style: getTextTheme(color: COLOR_PRIMARY).headlineLarge),
            addVerticalSpace(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingLabelEditBox(labelText: "Search...", 
              controller: _searchController),
            ),

            ..._filteredItems.map((song){
              return ListTile(
                title: Text('data'),
              );
            }).toList()
          ],
        ),
      ),
    ));
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

    var body = {"query": query, 'userId' : await getUserId()};
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