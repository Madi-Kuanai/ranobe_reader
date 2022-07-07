import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../consts.dart';

class UpdatedSectionCard extends StatelessWidget {
  NewChaptersModel? model;
  late double width;
  late double height;
  ThemeData? themeData;

  UpdatedSectionCard(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    TextStyle titleStyle =
        GoogleFonts.notoSans(color: themeData?.colorScheme.onPrimary);
    return SizedBox(
      width: width * 0.6,
      height: height * 0.3,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(Const.ranobeMeDomain + model!.coverLink),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.015),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.4,
                  height: height * 0.06,
                  child: AutoSizeText(
                    model!.name,
                    maxLines: 3,
                    style: titleStyle,
                    presetFontSizes: const [16, 14, 10],
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  height: height * 0.05,
                  child: AutoSizeText(
                    "Добавлено глав: " + model!.howMany.toString(),
                    maxLines: 3,
                    style: titleStyle,
                    presetFontSizes: const [12, 10],
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  height: height * 0.03,
                  child: AutoSizeText(
                    model!.updateAt.toString(),
                    maxLines: 3,
                    style: titleStyle,
                    presetFontSizes: const [12, 10],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
