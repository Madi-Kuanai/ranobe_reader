import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/backend/ParseRanobe/getHomeInfo.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:ranobe_reader/screens/homeScreen/components/MiniCard.dart';
import 'package:ranobe_reader/screens/homeScreen/components/cardOfUpdates.dart';
import 'package:ranobe_reader/screens/listOfRanobeScreen/listOfRanobeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeData? themeData;
  double? width;
  double? height;
  List<NewChaptersModel>? lstOfNewCh;
  List<DefaultRanobeModel>? lstOfPopular = [];
  Color? textColor;
  StreamController? controller = StreamController<DefaultRanobeModel>();
  StreamSubscription? subscription;
  bool isInternetError = false;

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    textColor = themeData?.colorScheme.onPrimary;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    TextStyle headerStyle =
        GoogleFonts.notoSans(color: textColor, fontWeight: FontWeight.bold);
    return lstOfNewCh != null && lstOfPopular!.length > 3 && !isInternetError
        ? Container(
            margin: EdgeInsets.only(left: width! * 0.035),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Обновления",
                    style: headerStyle,
                  ),
                  margin: EdgeInsets.only(
                    top: height! * 0.01,
                  ),
                ),
                buildUpdatedRanobe(),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Популярные",
                    style: headerStyle,
                  ),
                  margin: EdgeInsets.only(
                    top: height! * 0.02,
                  ),
                ),
                buildPopularsChoice(context),
                buildPopulars()
              ],
            ),
          )
        : isInternetError
            ? Container()
            : Container();
  }

  SingleChildScrollView buildPopularsChoice(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          GestureDetector(
            child: buildTimeframes("За 7 дней", 0.25),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return listOfRanobeScreen(
                    function: PopularRanobe().parseTitlesAndHrefOfPopularRanobe,
                    param: "");
              }));
            },
          ),
          GestureDetector(
            child: buildTimeframes("За все время", 0.3),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return listOfRanobeScreen(
                    function: PopularRanobe().parseTitlesAndHrefOfPopularRanobe,
                    param: "?top=stat_all");
              }));
            },
          ),
          GestureDetector(
            child: buildTimeframes("За сегодня", 0.3),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return listOfRanobeScreen(
                    function: PopularRanobe().parseTitlesAndHrefOfPopularRanobe,
                    param: "?top=stat_today");
              }));
            },
          ),
          GestureDetector(
            child: buildTimeframes("За вчера", 0.25),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return listOfRanobeScreen(
                    function: PopularRanobe().parseTitlesAndHrefOfPopularRanobe,
                    param: "?top=stat_yesterday");
              }));
            },
          ),
        ],
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Container buildPopulars() {
    return Container(
      margin: EdgeInsets.only(top: height! * 0.025),
      width: width,
      height: height! * 0.15,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: lstOfPopular!.length,
          itemBuilder: (context, index) =>
              MiniCardsOfRanobe(ranobeModel: lstOfPopular![index])),
    );
  }

  Container buildTimeframes(String text, double widthCoef) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height! * 0.01, horizontal: width! * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width! * widthCoef,
            height: height! * 0.03,
            padding: EdgeInsets.all(width! * 0.0025),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.cyanAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeData?.scaffoldBackgroundColor,
              ),
              alignment: Alignment.center,
              child: AutoSizeText(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildUpdatedRanobe() {
    return Container(
      width: double.infinity,
      height: height! * 0.3,
      margin: EdgeInsets.only(top: height! * 0.01),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: lstOfNewCh?.length,
        itemBuilder: (context, index) {
          return newChaptersCard(ranobeModel: lstOfNewCh![index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: width! * 0.03,
            crossAxisSpacing: width! * 0.03,
            childAspectRatio: 0.4),
      ),
    );
  }

  void initInfo() {
    try {
      if (mounted) {
        NewChapters().parseNewChapters().then((value) {
          setState(() {
            lstOfNewCh = value;
          });
        });
        PopularRanobe().parsePopularsForMiniCards(controller!, "");
        subscription = controller?.stream.listen((event) {
          if (lstOfPopular!.length < 25) {
            setState(() {
              lstOfPopular?.add(event);
            });
          } else {
            subscription?.cancel();
          }
        });
      }
    } catch (ex) {
      if (ex.runtimeType == SocketException) {
        setState(() {
          isInternetError = true;
        });
      }
    }
  }
}
