import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../const.dart';
import '../../RanobeScreen/RanobeScreen.dart';

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
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RanobePage(
                model: model as RanobeModel,
              ),
            ));
      },
        child: SizedBox(
      width: width * 0.6,
      height: height * 0.3,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(model!.domainLink + model!.coverLink),
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
                Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  width: width * 0.4,
                  height: height * 0.025,
                  child: AutoSizeText(
                    "Добавлено глав: " + model!.howMany.toString(),
                    maxLines: 3,
                    style: titleStyle,
                    presetFontSizes: const [13, 12],
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
    ));
  }
}
