import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/backend/ParseRanobe/getHomeInfo.dart';
import 'package:ranobe_reader/settings/preferenceService.dart';
import '../../../consts.dart';
import '../../../models/ranobeModel.dart';

class CardOfListRanobe extends StatefulWidget {
  final title, href;
  final int rating;
  final Color colorOfRatingImage;

  CardOfListRanobe(
      {required this.title,
      required this.href,
      required this.rating,
      required this.colorOfRatingImage,
      Key? key})
      : super(key: key);

  @override
  State<CardOfListRanobe> createState() =>
      _CardOfListRanobeState(title, href, rating, colorOfRatingImage);
}

class _CardOfListRanobeState extends State<CardOfListRanobe> {
  _CardOfListRanobeState(
      this.title, this.href, this.rating, this.colorOfRatingImage);

  final title, href;
  final int rating;
  final Color colorOfRatingImage;
  late double width, height;
  ThemeData? themeData;
  DefaultRanobeModel? model;
  String? typeFavourite;
  int? selectedIndex;
  int? lastIndex;
  int? tempSelectedChoiceChipIndex;
  List<String> itemsTitleOfDropdown = [
    "Прочитано",
    "Брошено",
    "Отложено",
    "Запланировано",
    "Читаю"
  ];

  @override
  void initState() {
    super.initState();
    initOtherInforms();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    themeData = Theme.of(context);

    TextStyle titleStyle =
        GoogleFonts.notoSans(color: themeData?.colorScheme.onPrimary);

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      width: width,
      height: height * 0.15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildCover(),
          //We split cover and another informs in 2 parts
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.01,
                    left: width * 0.02,
                    bottom: height * 0.01),
                width: width * 0.7,
                height: height * 0.06,
                child: AutoSizeText(
                  title,
                  maxLines: 3,
                  style: titleStyle,
                  presetFontSizes: const [14, 12, 10],
                ),
              ),
              buildAdderToLibrary(context),
              buildGenres()
            ],
          )
        ],
      ),
    );
  }

  Container buildGenres() {
    return Container(
      margin: EdgeInsets.only(top: height * 0.01, left: width * 0.03),
      width: width * 0.73,
      height: height * 0.03,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return genreCard(model?.genres?.keys.elementAt(index),
              model?.genres![model?.genres?.keys.elementAt(index)]);
        },
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.start,
        shrinkWrap: true,
        itemCount: model?.genres?.keys.length,
      ),
    );
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
                              color: themeData?.scaffoldBackgroundColor,
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
                                  color: themeData!.colorScheme.onPrimary,
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
                          "0", lastIndex.toString(), model!);
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
                          "1", lastIndex.toString(), model!);
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
                          "2", lastIndex.toString(), model!);
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
                          "3", lastIndex.toString(), model!);
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
                          "4", lastIndex.toString(), model!);
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
                          lastIndex.toString(), model!);
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
        height: height * 0.03,
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: themeData!.colorScheme.onPrimary),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.only(left: width * 0.025),
        child: AutoSizeText(
          typeFavourite ?? "",
          style: TextStyle(color: themeData?.colorScheme.onPrimary),
        ),
      ),
    );
  }

  Container buildChoiceChip(
      Icon icon, String text, int tempIndex, double tempCoef) {
    return Container(
        width: width * tempCoef,
        height: height * 0.05,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: height * 0.01),
        decoration: BoxDecoration(
            color: tempIndex ==
                    (tempSelectedChoiceChipIndex ??
                        999 /* 999 если ничего не выбрано */)
                ? themeData?.colorScheme.onPrimary
                : themeData!.chipTheme.secondarySelectedColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(color: themeData!.colorScheme.onPrimary)),
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
                    ? themeData!.scaffoldBackgroundColor
                    : themeData?.colorScheme.onPrimary,
              ),
            ),
          ],
        ));
  }

  SizedBox buildCover() {
    return SizedBox(
      child: FittedBox(
        fit: BoxFit.fill,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              model?.coverLink != null
                  ? Image.network(Const.ranobeDomain + model?.coverLink!)
                  : Container(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10)),
                    color: colorOfRatingImage),
                width: width * 0.125,
                height: height * 0.085,
                alignment: Alignment.center,
                child: AutoSizeText(
                  rating.toString(),
                  maxLines: 1,
                  presetFontSizes: const [30, 25],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
      height: height * 0.2,
      width: width * 0.225,
    );
  }

  void initOtherInforms() {
    if (mounted) {
      DefaultRanobe().parseRanobeByLink(href, title).then((value) {
        if (mounted) {
          setState(() {
            model = value;
            typeFavourite = PreferenceService.checkFavourite(
                    Const.readKey.toString(), model)
                ? "Прочитано"
                : PreferenceService.checkFavourite(
                        Const.abandonedKey.toString(), model)
                    ? "Брошено"
                    : PreferenceService.checkFavourite(
                            Const.postponedKey.toString(), model)
                        ? "Отложено"
                        : PreferenceService.checkFavourite(
                                Const.plannedKey.toString(), model)
                            ? "Запланировано"
                            : PreferenceService.checkFavourite(
                                    Const.readingKey.toString(), model)
                                ? "Читаю"
                                : "Добавить к";
          });
        }
      });
    }
    /*

Read -Прочитано
Abandoned - Брошено
Postponed - Отложено
Planned - Запланировано
Reading - Читаю
* */
  }

  Container genreCard(genreTitle, href) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.005, vertical: height * 0.001),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff3D60D7), width: 1.25)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.003),
        child: AutoSizeText(genreTitle ?? "",
            presetFontSizes: const [14],
            style: TextStyle(
              color: themeData?.colorScheme.onPrimary,
            )),
      ),
    );
  }
}
