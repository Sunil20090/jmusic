import 'package:jmusic/constants/storage_constant.dart';
import 'package:jmusic/utils/storage_service.dart';

class SettingUtils {
  static const int REPEAT_ONE = 1;
  static const int REPEAT_ALL = 2;
  static const int REPEAT_NO = 0;

  static const int SUFFLE_ON = 1;
  static const int SUFFLE_OFF = 0;

  static int repeatType = REPEAT_NO;
  static int suffleType = SUFFLE_OFF;

  static initSetting() async {
    var settingJson = await loadJson(SETTING_KEY);
    repeatType = settingJson['repeatType'];
    suffleType = settingJson['suffleType'];
  }

  static _saveSetting() async {
    var obj = {'repeatType': repeatType, 'suffleType': suffleType};

    await saveJson(SETTING_KEY, obj);
  }

  static toggleRepeat() {
    if (repeatType == REPEAT_ONE) {
      repeatType = REPEAT_NO;
    } else if (repeatType == REPEAT_NO) {
      repeatType = REPEAT_ALL;
    } else {
      repeatType = REPEAT_ONE;
    }

    _saveSetting();
  }

  static void toggleSuffle() {
    if (suffleType == SUFFLE_OFF) {
      suffleType = SUFFLE_ON;
    } else {
      suffleType = SUFFLE_OFF;
    }

    _saveSetting();
  }
}
