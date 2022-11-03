import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ranobe_reader/backend/ParseRanobe/getHomeInfo.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:ranobe_reader/screens/homeScreen/components/CardsWithDescription.dart';
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
  double? width, height;
  List<NewChaptersModel>? lstOfNewCh;
  List<DefaultRanobeModel>? lstOfPopular = [];
  List<CardsWithDescription>? lstOfStat = [];
  Color? textColor;
  StreamController? controller = StreamController<DefaultRanobeModel>();
  StreamSubscription? subscription;
  bool isInternetError = false;
  int pageNum = 1;

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
    return lstOfNewCh != null &&
            lstOfPopular!.length > 3 &&
            !isInternetError &&
            lstOfStat != null
        ? Container(
            margin: EdgeInsets.only(left: width! * 0.035),
            child: SingleChildScrollView(
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
                  UpdatedRanobesWidget(
                      height: height, lstOfNewCh: lstOfNewCh, width: width),
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
                  PopularTimeFrameWidget(
                      height: height,
                      width: width,
                      themeData: themeData,
                      textColor: textColor,
                      context: context),
                  PopularsWidget(
                      height: height, width: width, lstOfPopular: lstOfPopular),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: height! * 0.01),
                    child: Text(
                      "Топ по количеству просмотров",
                      style: headerStyle,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: height! * 0.01),
                      child: SizedBox(
                          width: width,
                          child: Column(
                            children: <Widget>[
                              ...?lstOfStat?.map((e) => e),
                              ElevatedButton(
                                onPressed: () {
                                  parseRanobeByStatic()
                                      .then((value) => setState(() {}));
                                },
                                child: AutoSizeText(
                                  "Загрузить",
                                  style: TextStyle(
                                      color:
                                          themeData!.scaffoldBackgroundColor),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        themeData?.colorScheme.onPrimary)),
                              )
                            ],
                          )))
                ],
              ),
            ))
        : isInternetError
            ? Container()
            : Center(
                child: Lottie.asset(
                  "assets/animations/loadingAnimation.json",
                  width: width! * 0.5,
                  height: height! * 0.6,
                ),
              );
  }

  Future<void> parseRanobeByStatic() async {
    try {
      if (mounted) {
        setState(() {
          ParseByStatistic.parseByStat(pageNum).then((value) {
            lstOfStat?.addAll(value.map((e) => CardsWithDescription(e)));
          });
          pageNum++;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //Загружаем основные информации
  void initInfo() {
    try {
      if (mounted) {
        NewChapters().parseNewChapters().then((value) {
          if (mounted) {
            setState(() {
              lstOfNewCh = value;
            });
          }
        });
        PopularRanobe().parsePopularsForMiniCards(controller!, "");
        subscription = controller?.stream.listen((event) {
          if (lstOfPopular!.length < 25) {
            if (mounted) {
              setState(() {
                lstOfPopular?.add(event);
              });
            }
          } else {
            subscription?.cancel();
          }
        });
        parseRanobeByStatic();
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

class PopularTimeFrameWidget extends StatelessWidget {
  const PopularTimeFrameWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.themeData,
    required this.textColor,
    required this.context,
  }) : super(key: key);

  final double? height;
  final double? width;
  final ThemeData? themeData;
  final Color? textColor;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          GestureDetector(
            child: TimeframesWidget(
                height: height,
                width: width,
                themeData: themeData,
                textColor: textColor,
                text: "За 7 дней",
                widthCoef: 0.25),
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
            child: TimeframesWidget(
                height: height,
                width: width,
                themeData: themeData,
                textColor: textColor,
                text: "За все время",
                widthCoef: 0.3),
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
            child: TimeframesWidget(
                height: height,
                width: width,
                themeData: themeData,
                textColor: textColor,
                text: "За сегодня",
                widthCoef: 0.3),
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
            child: TimeframesWidget(
                height: height,
                width: width,
                themeData: themeData,
                textColor: textColor,
                text: "За вчера",
                widthCoef: 0.25),
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
}
//Раздел обновления

class UpdatedRanobesWidget extends StatelessWidget {
  const UpdatedRanobesWidget({
    Key? key,
    required this.height,
    required this.lstOfNewCh,
    required this.width,
  }) : super(key: key);

  final double? height;
  final List<NewChaptersModel>? lstOfNewCh;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height! * 0.3,
      margin: EdgeInsets.only(top: height! * 0.01),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: lstOfNewCh?.length,
        itemBuilder: (context, index) {
          return UpdatedSectionCard(lstOfNewCh![index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: width! * 0.03,
            crossAxisSpacing: width! * 0.03,
            childAspectRatio: 0.4),
      ),
    );
  }
}

class TimeframesWidget extends StatelessWidget {
  const TimeframesWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.themeData,
    required this.textColor,
    required this.text,
    required this.widthCoef,
  }) : super(key: key);

  final double? height;
  final double? width;
  final ThemeData? themeData;
  final Color? textColor;
  final String text;
  final double widthCoef;

  @override
  Widget build(BuildContext context) {
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
}

class PopularsWidget extends StatelessWidget {
  const PopularsWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.lstOfPopular,
  }) : super(key: key);

  final double? height;
  final double? width;
  final List<DefaultRanobeModel>? lstOfPopular;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height! * 0.01, bottom: height! * 0.01),
      width: width,
      height: height! * 0.15,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: lstOfPopular!.length,
          itemBuilder: (context, index) =>
              MiniCardsOfRanobe(lstOfPopular![index])),
    );
  }
}
