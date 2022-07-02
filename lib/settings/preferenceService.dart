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

  static addFavourite(
      String key, String lastKey, DefaultRanobeModel model) async {
    deleteFavourite(lastKey, model);
    List<String>? lst = _pref?.getStringList(key);
    print("PrefCheck: Length: ${lst?.length ?? 0}");
    lst?.add(jsonEncode(model.toJson()));
    print(
        "PostCheck: Key: ${key}; LastKey ${lastKey}; Length: ${lst?.length ?? 0}");
    await _pref?.setStringList(key, lst ?? [jsonEncode(model.toJson())]);
  }

  static deleteFavourite(String key, DefaultRanobeModel model) async {
    List<String>? lst = _pref?.getStringList(key);
    if (checkFavourite(key, model)) {
      lst?.remove(jsonEncode(model.toJson()));
      await _pref?.setStringList(key, lst ?? []);
    } else {
      print("Error on deleting");
    }
  }

  static List<String>? getListOfFavouritesByKey(String key) {
    return _pref?.getStringList(key);
  }

  static bool checkFavourite(String key, DefaultRanobeModel? model) {
    return _pref?.getStringList(key)?.contains(jsonEncode(model?.toJson())) ??
        false;
  }
}
