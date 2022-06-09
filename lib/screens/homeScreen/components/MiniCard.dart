import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../consts.dart';

class MiniCardsOfRanobe extends StatefulWidget {
  DefaultRanobeModel ranobeModel;

  MiniCardsOfRanobe({required this.ranobeModel, Key? key}) : super(key: key);

  @override
  State<MiniCardsOfRanobe> createState() =>
      _MiniCardsOfRanobeState(ranobeModel);
}

class _MiniCardsOfRanobeState extends State<MiniCardsOfRanobe> {
  DefaultRanobeModel? model;
  late double width;
  late double height;
  ThemeData? themeData;

  _MiniCardsOfRanobeState(this.model);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    TextStyle titleStyle =
        GoogleFonts.notoSans(color: themeData?.colorScheme.onPrimary);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: width * 0.225,
                height: height * 0.3,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child:
                        Image.network(Const.ranobeDomain + model!.coverLink)),
              )),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: themeData!.shadowColor.withOpacity(0.6),
                blurRadius: 5,
              )
            ]),
            width: width * 0.21,
            height: height * 0.035,
            margin: EdgeInsets.only(bottom: height * 0.0025),

            child: AutoSizeText(
              model!.name,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          )
        ]));
  }
}
