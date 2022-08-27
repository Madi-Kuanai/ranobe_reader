// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:ranobe_reader/components.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';

import '../../const.dart';
import '../../settings/preferenceService.dart';
import '../readerScreen/ReaderScreen.dart';

class RanobePage extends StatelessWidget {
  RanobeModel model;
  late double width, height;
  late ThemeData themeData;

  RanobePage({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var picture = Image.network(
      model.domainLink + model.coverLink,
      fit: BoxFit.cover,
    );
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: height * 0.015,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: themeData.scaffoldBackgroundColor),
              ),
            ),
            iconTheme: IconThemeData(color: themeData.scaffoldBackgroundColor),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  SizedBox(
                    child: picture,
                    width: width,
                    height: height * 0.3,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 20),
                    child: Container(
                      color: themeData.scaffoldBackgroundColor.withOpacity(0.2),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.3,
                          height: height * 0.2,
                          padding: EdgeInsets.only(left: width * 0.025),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: picture),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: width * 0.03),
                                    width: width * 0.5,
                                    height: height * 0.05,
                                    child: AutoContrastText(
                                      text: model.name,
                                      imageProvider: NetworkImage(
                                          model.domainLink + model.coverLink),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color:
                                            themeData.scaffoldBackgroundColor,
                                      ))
                                ],
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(
                              top: height * 0.04, left: width * 0.02),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 120, bottom: 120),
              centerTitle: false,
              stretchModes: const [StretchMode.zoomBackground],
            ),
            stretch: true,
            pinned: true,
            expandedHeight: height * 0.3,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin:
                  EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EpubViewer(
                                        model.id,
                                        model.domainLink ==
                                                "https://ranobehub.org/"
                                            ? 0
                                            : 1),
                                  ));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeData.primaryColor,
                                  border: Border.all(
                                      color: themeData.colorScheme.onPrimary,
                                      width: 1)),
                              width: width * 0.7,
                              height: height * 0.05,
                              child: Text(
                                "Читать",
                                style: TextStyle(
                                    color: themeData.scaffoldBackgroundColor),
                              ),
                            )),
                        FavouriteWidget(name: model.name)
                      ],
                    ),
                  ),
                  DescriptionWidget(
                    href: model.href,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: themeData.colorScheme.onPrimary,
                                    width: 1)),
                            width: width * 0.25,
                            height: height * 0.05,
                            child: Text(
                              "Скачать",
                              style: TextStyle(
                                  color: themeData.colorScheme.onPrimary),
                            ),
                          ),
                        ),
                        AdderToLibraryWidget(name: model.name)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
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

class AutoContrastText extends StatefulWidget {
  String text;
  ImageProvider imageProvider;

  AutoContrastText({required this.text, required this.imageProvider, Key? key})
      : super(key: key);

  @override
  State<AutoContrastText> createState() => _AutoContrastTextState();
}

class _AutoContrastTextState extends State<AutoContrastText> {
  double? computeLuminance;

  @override
  void initState() {
    getImagePalette(widget.imageProvider).then((value) {
      if (mounted) {
        setState(() {
          computeLuminance = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      widget.text,
      presetFontSizes: const [16, 14, 12],
      maxLines: 3,
      style: TextStyle(
          color: (computeLuminance ?? 0) > 0.05 ? Colors.black : Colors.white,
          fontWeight: FontWeight.w400),
    );
  }

  Future<double> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color.computeLuminance();
  }
}
