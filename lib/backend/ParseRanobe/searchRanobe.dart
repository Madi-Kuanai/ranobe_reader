import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../models/ranobeModel.dart';

class SearchRanobe {
  static Future<List<RanobeModel>?> initData({String query = ""}) async {
    try {
      final String response =
          await rootBundle.loadString("assets/json/ranobeJSON.json");
      List data = await json.decode(response);
      List<RanobeModel> listOfRanobe = [];
      data
          .where((element) => element["title"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .forEach((element) {
        listOfRanobe.add(RanobeModel(
            int.parse(element["linkToRanobe"]
                .toString()
                .replaceAll("https://ranobehub.org/ranobe/", "")
                .split("-")[0]),
            element["title"],
            element["linkToRanobe"],
            element["linksToCover"]["linkOfHighCover"]
                .toString()
                .replaceFirst("https://ranobehub.org/", ""),
            "https://ranobehub.org/"));
      });
      return listOfRanobe;
    } catch (e) {
      throw Exception(e);
    }
  }
}
