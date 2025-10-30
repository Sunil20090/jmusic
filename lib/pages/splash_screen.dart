import 'package:jmusic/constants/image_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/pages/dashboard/song_list.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/utils/settings/setting_utils.dart';
import 'package:jmusic/utils/user/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SettingUtils.initSetting();
    initUser().then((value) {
      moveToDashBoard();
    });
  }

  initUser() async {
    var user = await loadUser();

    if (user == null || user['id'] == null) {
      ApiResponse response = await getService(URL_GUEST_USER);
      if (response.isSuccess) {
        await saveUser(response.body);
        user = response.body;
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 50, height: 50, child: Image.asset(ICON_APP)),
          ],
        ),
      ],
    );
  }

  moveToDashBoard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (builder) => SongList()),
    );
  }
}
