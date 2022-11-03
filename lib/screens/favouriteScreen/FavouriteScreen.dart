import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ranobe_reader/const.dart';


class FavouriteScreen extends StatelessWidget {
  late ThemeData themeData;
  late double width, height;

  FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 6,
        child: Scaffold(
            appBar: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(
                          Icons.done_all,
                          color: themeData.colorScheme.onPrimary,
                        ),
                        s: "Прочитано",
                        widthCoef: 0.275)),
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(Icons.delete_outline,
                            color: themeData.colorScheme.onPrimary),
                        s: "Брошено",
                        widthCoef: 0.25)),
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(Icons.watch_later_outlined,
                            color: themeData.colorScheme.onPrimary),
                        s: "Отложено",
                        widthCoef: 0.275)),
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(Icons.done,
                            color: themeData.colorScheme.onPrimary),
                        s: "Запланировано",
                        widthCoef: 0.4)),
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(Icons.calendar_today_rounded,
                            color: themeData.colorScheme.onPrimary),
                        s: "Читаю",
                        widthCoef: 0.27)),
                Tab(
                    child: TabTitles(
                        width: width,
                        themeData: themeData,
                        icon: Icon(Icons.menu_book_sharp,
                            color: themeData.colorScheme.onPrimary),
                        s: "Избранные",
                        widthCoef: 0.34)),
              ],
            ),
            body: const TabBarView(children: [
              FavouritesPageWidget(index: Const.readKey),
              FavouritesPageWidget(
                index: Const.abandonedKey,
              ),
              FavouritesPageWidget(index: Const.postponedKey),
              FavouritesPageWidget(index: Const.plannedKey),
              FavouritesPageWidget(index: Const.readingKey),
              FavouritesPageWidget(index: null),
            ])));
  }
}

class TabTitles extends StatelessWidget {
  const TabTitles({
    Key? key,
    required this.width,
    required this.themeData,
    required this.icon,
    required this.s,
    required this.widthCoef,
  }) : super(key: key);

  final double width;
  final ThemeData themeData;
  final Icon icon;
  final String s;
  final double widthCoef;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width * widthCoef,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon,
            AutoSizeText(
              s,
              presetFontSizes: const [16, 15, 14, 10],
              style: TextStyle(color: themeData.colorScheme.onPrimary),
            )
          ],
        ));
  }
}

class FavouritesPageWidget extends StatefulWidget {
  final int? index;

  const FavouritesPageWidget({required this.index, Key? key}) : super(key: key);

  @override
  State<FavouritesPageWidget> createState() => _FavouritesPageWidgetState();
}

class _FavouritesPageWidgetState extends State<FavouritesPageWidget> {
  late double width, height;
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    themeData = Theme.of(context);
    return Container(
        margin: const EdgeInsets.only(left: 50),
        child: Text(
          widget.index.toString(),
          style: TextStyle(color: themeData.colorScheme.onPrimary),
        ));
  }
}

/*

Read -Прочитано
Abandoned - Брошено
Postponed - Отложено
Planned - Запланировано
Reading - Читаю
* */
