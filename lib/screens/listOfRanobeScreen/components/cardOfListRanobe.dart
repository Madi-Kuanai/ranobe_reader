import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/backend/ParseRanobe/getHomeInfo.dart';
import '../../../consts.dart';
import '../../../models/ranobeModel.dart';

class CardOfListRanobe extends StatefulWidget {
  final title, href;
  final int rating;
  final Color color;

  CardOfListRanobe(
      {required this.title,
      required this.href,
      required this.rating,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  State<CardOfListRanobe> createState() =>
      _CardOfListRanobeState(title, href, rating, color);
}

class _CardOfListRanobeState extends State<CardOfListRanobe> {
  _CardOfListRanobeState(this.title, this.href, this.rating, this.color);

  final title, href;
  Map<String, String> genres = {};
  final int rating;
  final Color color;
  late double width, height;
  ThemeData? themeData;
  DefaultRanobeModel? model;

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
          SizedBox(
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
                          color: color),
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
            height: height * 0.15,
            width: width * 0.225,
          ),
          Column(
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
            ],
          )
        ],
      ),
    );
  }

  void initOtherInforms() {
    if (mounted) {
      DefaultRanobe().parseRanobeByLink(href, title).then((value) {
        setState(() {
          model = value;
        });
      });
    }
  }
}
