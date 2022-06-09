/*
* {Madi Kuanai}
*/
import 'dart:convert';

import 'package:ranobe_reader/consts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static bool isDarkMode() {
    return _pref?.getBool(Const.isDarkKey) ?? false;
  }

  static Future setDarkMode() async {
    await _pref?.setBool(Const.isDarkKey, true);
  }

  static Future setLightMode() async {
    await _pref?.setBool(Const.isDarkKey, false);
  }

  static bool checkFavourite(String key) {
    return _pref!.containsKey(key);
  }

  static deleteFavourite(String key) async {
    if (_pref!.containsKey(key)) await _pref!.remove(key);
  }

  static addFavourite(String key, DefaultRanobeModel ranobe) async {
    await _pref!.setString(key, jsonEncode(ranobe.toJson()));
  }

  static DefaultRanobeModel getFavourite(String string) {
    return DefaultRanobeModel.fromJson(jsonDecode(string));
  }

  static getFavourites() {
    return _pref!.getKeys();
  }
}
