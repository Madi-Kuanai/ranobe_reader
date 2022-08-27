/*
* {Madi Kuanai}
*/

import 'package:ranobe_reader/const.dart';
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

  static addFavourite(String key, String lastKey, String model) async {
    deleteFavourite(lastKey, model);
    List<String>? lst = _pref?.getStringList(key);
    lst?.add(model);
    await _pref?.setStringList(key, lst ?? [model]);
  }

  static deleteFavourite(String key, String model) async {
    List<String>? lst = _pref?.getStringList(key);
    if (checkFavourite(key, model)) {
      lst?.remove(model);
      await _pref?.setStringList(key, lst ?? []);
    } else {
      print("Error on deleting");
    }
  }

  static List<String>? getListOfFavouritesByKey(String key) {
    return _pref?.getStringList(key);
  }

  static bool checkFavourite(String key, String? model) {
    return _pref?.getStringList(key)?.contains(model) ?? false;
  }
}
