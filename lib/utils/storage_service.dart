import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

saveJson(String key, dynamic jsonObj) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, jsonEncode(jsonObj));
}

Future<dynamic> loadJson(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    String? jsonString = prefs.getString(key);
      // print('jsonString = $jsonString');

    if (jsonString != null) {
      return jsonDecode(jsonString);
    } else {
      return null;
    }
    // return jsonDecode(jsonString!);
  } else {
    return null;
  }
}

Future deleteJson(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    await prefs.remove(key);
    print('$key deleted');
  } else {
    print('$key does not exist');
  }
}