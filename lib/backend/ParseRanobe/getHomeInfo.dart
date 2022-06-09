import 'dart:async';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ranobe_reader/MyErrors.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';

class NewChapters {
  Future<List<NewChaptersModel>> parseNewChapters() async {
    List<NewChaptersModel> NewChaptersList = [];
    try {
      //news_item - class of each card
      var url = Uri.parse("https://ranobe.me/news");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var document = parse(response.body);
        for (int i = 0;
            i < document.getElementsByClassName("news_item").length;
            i++) {
          var item = document.getElementsByClassName("news_item")[i];
          var coverLink = item
              .getElementsByClassName("news_cover")[0]
              .getElementsByTagName("img")
              .map((e) => e.attributes["src"])
              .first;
          var name = item
              .getElementsByClassName("FicTable_Title")[0]
              .getElementsByTagName("a")[0]
              .text;
          var href = item
              .getElementsByClassName("FicTable_Title")[0]
              .getElementsByTagName("a")
              .map((e) => e.attributes["href"])
              .first;
          var id = href?.replaceFirst("/ranobe", "");
          var howMany = item
              .getElementsByClassName("FicTable_Title")[0]
              .parent
              ?.text
              .trim()
              .split("Добавлен")[1]
              .split(" глав")[0]
              .split(" ")[1];
          Map<String, String> newChapters = getMapOfNewChapters(item);
          var updateAt =
              getUpdateTime(item.getElementsByClassName("uptodate").first.text);

          NewChaptersList.add(NewChaptersModel(
              id: int.parse(id!),
              name: name,
              href: href!,
              coverLink: coverLink ?? "NULL",
              howMany: int.parse(howMany!),
              newChapters: newChapters,
              updateAt: updateAt,
              genres: {}));
        }
      } else {
        throw StatusError("Status error is: " + response.statusCode.toString());
      }
    } catch (ex) {
      throw Exception(ex.toString());
    }
    return NewChaptersList;
  }

  String getUpdateTime(String text) {
    return text.contains('назад')
        ? "Сегодня"
        : text.contains("сегодня")
            ? "Сегодня"
            : text.contains("вчера")
                ? "Вчера"
                : text.split(" ")[0] + " " + text.split(" ")[1];
  }

  Map<String, String> getMapOfNewChapters(item) {
    Map<String, String> newChapters = {};
    var el = item
        .getElementsByClassName("news_chapters_list")[0]
        .getElementsByTagName("a");
    for (int j = 0; j < el.length; j++) {
      newChapters[el[j].text] = el.map((e) => e.attributes["href"]!).first;
    }
    return newChapters;
  }
}

class PopularRanobe {
  Future<void> parsePopularsForMiniCards(
      StreamController controller, String param) async {
    try {
      var searchRequest =
          await http.get(Uri.parse("https://ranobe.me/stat" + param));
      if (searchRequest.statusCode == 200) {
        var document = parse(searchRequest.body);
        for (int i = 0;
            i < document.getElementsByClassName("fic").length;
            i++) {
          var item = document.getElementsByClassName("fic")[i];
          var href = item
              .getElementsByTagName("a")
              .map((e) => e.attributes["href"])
              .first;
          var title = item.getElementsByTagName("a").first.text;
          var temporaryDocument = parse(
              (await http.get(Uri.parse("https://ranobe.me" + href!))).body);
          Map<String, String> genres = {};
          for (var genre in temporaryDocument
              .getElementsByClassName("tr")[1]
              .getElementsByClassName("content")[0]
              .getElementsByTagName("a")) {
            genres[genre.text] = genre.attributes["href"].toString();
          }
          var coverLink = temporaryDocument
              .getElementsByClassName("FicCover")[0]
              .getElementsByTagName("img")[0]
              .attributes["src"]
              .toString();
          var description = temporaryDocument
              .getElementsByClassName("summary_text_fic3")
              .first
              .text
              .split("#")[0]
              .toString();
          controller.add(DefaultRanobeModel(
            id: int.parse(href.replaceFirst("/ranobe", "")),
            name: title,
            href: href,
            coverLink: coverLink,
            genres: genres,
          ));
        }
      } else {
        throw StatusError(
            "Status error. Status is: " + searchRequest.statusCode.toString());
      }
    } catch (ex) {
      print("Error: " + ex.runtimeType.toString());
    }
  }

  Future<Map<String, String>> parseTitlesAndHrefOfPopularRanobe(
      String param) async {
    try {
      Map<String, String> result = {};
      var searchRequest =
          await http.get(Uri.parse("https://ranobe.me/stat" + param));
      if (searchRequest.statusCode == 200) {
        var document = parse(searchRequest.body);
        for (int i = 0;
            i < document.getElementsByClassName("fic").length;
            i++) {
          var item = document.getElementsByClassName("fic")[i];
          var href = item
              .getElementsByTagName("a")
              .map((e) => e.attributes["href"])
              .first;
          var title = item.getElementsByTagName("a").first.text;
          result[title] = href.toString();
        }
        return result;
      } else {
        throw StatusError(
            "Status error. Status is: " + searchRequest.statusCode.toString());
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }
}

class DefaultRanobe {
  Future<DefaultRanobeModel> parseRanobeByLink(
      String href, String title) async {
    var temporaryDocument =
        parse((await http.get(Uri.parse("https://ranobe.me" + href))).body);
    Map<String, String> genres = {};
    for (var genre in temporaryDocument
        .getElementsByClassName("tr")[1]
        .getElementsByClassName("content")[0]
        .getElementsByTagName("a")) {
      genres[genre.text] = genre.attributes["href"].toString();
    }
    var coverLink = temporaryDocument
        .getElementsByClassName("FicCover")[0]
        .getElementsByTagName("img")[0]
        .attributes["src"]
        .toString();
    return DefaultRanobeModel(
      id: int.parse(href.replaceFirst("/ranobe", "")),
      name: title,
      href: href,
      coverLink: coverLink,
      genres: genres,
    );
  }
}
