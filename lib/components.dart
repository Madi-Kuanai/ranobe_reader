import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ranobe_reader/settings/preferenceService.dart';

import 'const.dart';

class DescriptionWidget extends StatefulWidget {
  final String href;

  const DescriptionWidget({required this.href, Key? key}) : super(key: key);

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  String? description;
  var width, height;

  @override
  void initState() {
    init(widget.href.contains("ranobehub")).then((value) {
      if (mounted) {
        setState(() {
          description = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      child: AutoSizeText(
        description ?? "",
        style: TextStyle(color: themeData.colorScheme.onPrimary),
        maxLines: null,
      ),
    );
  }

  Future<String?> init(bool isRanobeHub) async {
    var response = await http.get(Uri.parse(widget.href));
    if (response.statusCode == 200) {
      var document = parse(response.body);

      return isRanobeHub
          ? document.getElementsByClassName("book-description__text")[0].text
          : document
              .getElementById(
                  "summary_${widget.href.replaceFirst("https://ranobe.me/ranobe", "")}")!
              .text;
    }
  }
}

class FavouriteWidget extends StatefulWidget {
  final String name;

  const FavouriteWidget({required this.name, Key? key}) : super(key: key);

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool _isFavourite = false;
  late Box box;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.2,
      height: height * 0.1,
      child: IconButton(
          onPressed: () {
            deleteAddFromFavourite();
          },
          icon: Icon(
            !_isFavourite ? Icons.bookmark_border : Icons.bookmark,
            size: width * 0.075,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
    );
  }

  void deleteAddFromFavourite() {
    _isFavourite ? box.delete(widget.name) : box.put(widget.name, null);
    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  void init() async {
    box = await Hive.openBox('favourites');
    if (box.containsKey(widget.name)) {
      if (mounted) {
        setState(() {
          _isFavourite = true;
        });
      }
    }
  }
}

class AdderToLibraryWidget extends StatefulWidget {
  final String name;

  const AdderToLibraryWidget({required this.name, Key? key}) : super(key: key);

  @override
  State<AdderToLibraryWidget> createState() => _AdderToLibraryWidgetState();
}

class _AdderToLibraryWidgetState extends State<AdderToLibraryWidget> {
  int? selectedIndex, lastIndex, tempSelectedChoiceChipIndex;
  List<String> itemsTitleOfDropdown = [
    "Прочитано",
    "Брошено",
    "Отложено",
    "Запланировано",
    "Читаю"
  ];
  String? typeFavourite;
  late ThemeData themeData;
  late double width, height;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return buildAdderToLibrary(context);
  }

  GestureDetector buildAdderToLibrary(BuildContext context) {
    tempSelectedChoiceChipIndex = typeFavourite == itemsTitleOfDropdown[0]
        ? Const.readKey
        : typeFavourite == itemsTitleOfDropdown[1]
            ? Const.abandonedKey
            : typeFavourite == itemsTitleOfDropdown[2]
                ? Const.postponedKey
                : typeFavourite == itemsTitleOfDropdown[3]
                    ? Const.plannedKey
                    : typeFavourite == itemsTitleOfDropdown[4]
                        ? Const.readingKey
                        : 999;
    var isClickedOnce = false;
    setState(() {
      lastIndex = tempSelectedChoiceChipIndex;
    });

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) =>
                      Container(
                          decoration: BoxDecoration(
                              color: themeData.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width * 0.15,
                                height: height * 0.005,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: themeData.colorScheme.onPrimary,
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.015),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                spacing: width * 0.03,
                                children: [
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(Icons.done_all),
                                        "Прочитано",
                                        Const.readKey,
                                        0.35),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex =
                                            Const.readKey;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(Icons.delete_outline),
                                        "Брошено",
                                        Const.abandonedKey,
                                        0.35),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex =
                                            Const.abandonedKey;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(Icons.watch_later_outlined),
                                        "Отложено",
                                        Const.postponedKey,
                                        0.35),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex =
                                            Const.postponedKey;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(
                                            Icons.calendar_today_rounded),
                                        "Запланировано",
                                        Const.plannedKey,
                                        0.475),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex =
                                            Const.plannedKey;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(Icons.menu_book_sharp),
                                        "Читаю",
                                        Const.readingKey,
                                        0.35),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex =
                                            Const.readingKey;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: buildChoiceChip(
                                        const Icon(Icons.undo),
                                        "Отменить выбор",
                                        999,
                                        0.5),
                                    onTap: () {
                                      stateSetter(() {
                                        isClickedOnce = true;
                                        tempSelectedChoiceChipIndex = 999;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          )));
            }).whenComplete(() {
          if (isClickedOnce) {
            setState(() {
              selectedIndex = tempSelectedChoiceChipIndex;
              switch (selectedIndex) {
                case 0:
                  {
                    if (typeFavourite != itemsTitleOfDropdown[0]) {
                      PreferenceService.addFavourite(
                          "0", lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = itemsTitleOfDropdown[0];
                      });
                    }
                    break;
                  }
                case 1:
                  {
                    if (typeFavourite != itemsTitleOfDropdown[1]) {
                      PreferenceService.addFavourite(
                          "1", lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = itemsTitleOfDropdown[1];
                      });
                    }
                    break;
                  }
                case 2:
                  {
                    if (typeFavourite != itemsTitleOfDropdown[2]) {
                      PreferenceService.addFavourite(
                          "2", lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = itemsTitleOfDropdown[2];
                      });
                    }
                    break;
                  }
                case 3:
                  {
                    if (typeFavourite != itemsTitleOfDropdown[3]) {
                      PreferenceService.addFavourite(
                          "3", lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = itemsTitleOfDropdown[3];
                      });
                    }
                    break;
                  }
                case 4:
                  {
                    if (typeFavourite != itemsTitleOfDropdown[4]) {
                      PreferenceService.addFavourite(
                          "4", lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = itemsTitleOfDropdown[4];
                      });
                    }
                    break;
                  }
                case 999:
                  {
                    if (typeFavourite != "Добавить к") {
                      PreferenceService.deleteFavourite(
                          lastIndex.toString(), widget.name);
                      setState(() {
                        typeFavourite = "Добавить к";
                      });
                    }
                    break;
                  }
              }
            });
            setState(() {
              lastIndex = tempSelectedChoiceChipIndex;
            });
          }
        });
      },
      child: Container(
        width: width * 0.25,
        alignment: Alignment.center,
        height: height * 0.05,
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: themeData.colorScheme.onPrimary),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.only(left: width * 0.025),
        child: AutoSizeText(
          typeFavourite ?? "",
          style: TextStyle(color: themeData.colorScheme.onPrimary),
        ),
      ),
    );
  }

  Container buildChoiceChip(
      Icon icon, String text, int tempIndex, double tempCoef) {
    return Container(
        width: width * tempCoef,
        height: height * 0.055,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: height * 0.01),
        decoration: BoxDecoration(
            color: tempIndex ==
                    (tempSelectedChoiceChipIndex ??
                        999 /* 999 если ничего не выбрано */)
                ? themeData.colorScheme.onPrimary
                : themeData.chipTheme.secondarySelectedColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(color: themeData.colorScheme.onPrimary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: icon,
              margin: EdgeInsets.symmetric(horizontal: width * 0.03),
            ),
            AutoSizeText(
              text,
              textAlign: TextAlign.center,
              presetFontSizes: const [16, 14, 12],
              style: TextStyle(
                color: tempIndex == (tempSelectedChoiceChipIndex ?? 999)
                    ? themeData.scaffoldBackgroundColor
                    : themeData.colorScheme.onPrimary,
              ),
            ),
          ],
        ));
  }

  void init() {
    setState(() {
      if (mounted) {
        typeFavourite = PreferenceService.checkFavourite(
                Const.readKey.toString(), widget.name)
            ? "Прочитано"
            : PreferenceService.checkFavourite(
                    Const.abandonedKey.toString(), widget.name)
                ? "Брошено"
                : PreferenceService.checkFavourite(
                        Const.postponedKey.toString(), widget.name)
                    ? "Отложено"
                    : PreferenceService.checkFavourite(
                            Const.plannedKey.toString(), widget.name)
                        ? "Запланировано"
                        : PreferenceService.checkFavourite(
                                Const.readingKey.toString(), widget.name)
                            ? "Читаю"
                            : "Добавить к";
      }
    });
  }
}
