// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const isViewed = 'isViewed';
  static const email = 'UserEmail';
  static const password = 'Userpassword';
  static const uID = 'UserId';
  static const uFireStoreId = 'userFireStoreId';
  static const appOpenedCount = 'appopenedCount';

  /////
  static const isViewedPopUP = 'isViewedPopUP';

  static Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    var value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = prefs.getString(key) ?? "";
    return value;
  }

  static Future<void> savebool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getbool(String key) async {
    bool? value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = prefs.getBool(key);
    return value ?? false;
  }
}
