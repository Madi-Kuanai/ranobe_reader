import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';

class CardsWithDescription extends StatelessWidget {
  DefaultRanobeModel defaultRanobeModel;
  double? width, height;
  late ThemeData themeData;

  CardsWithDescription(this.defaultRanobeModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    TextStyle titleStyle =
        GoogleFonts.notoSans(color: themeData.colorScheme.onPrimary);
    return Container(
      margin: EdgeInsets.symmetric(vertical: height! * 0.0055),
      width: width,
      height: height! * 0.2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                  defaultRanobeModel.domainLink + defaultRanobeModel.coverLink),
            ),
            width: width! * 0.3,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: width! * 0.025),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width! * 0.6,
                  height: height! * 0.06,
                  child: AutoSizeText(
                    defaultRanobeModel.name,
                    style: titleStyle,
                    presetFontSizes: const [16, 14, 10],
                  ),
                ),
                SizedBox(
                  width: width! * 0.6,
                  height: height! * 0.090,
                  child: AutoSizeText(
                    defaultRanobeModel.description,
                    style: GoogleFonts.notoSans(
                      color: themeData.colorScheme.onPrimary,
                    ),
                    presetFontSizes: const [14, 12],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                buildGenres()
                // SizedBox(
                //   width: width! * 0.4,
                //   height: height! * 0.03,
                //   child: AutoSizeText(
                //     ""
                //     maxLines: 3,
                //     style: titleStyle,
                //     presetFontSizes: const [12, 10],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildGenres() {
    return Container(
      margin: EdgeInsets.only(right: width! * 0.01),
      width: width! * 0.6,
      height: height! * 0.03,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return genreCard(
              defaultRanobeModel.genres?.keys.elementAt(index),
              defaultRanobeModel
                  .genres![defaultRanobeModel.genres?.keys.elementAt(index)]);
        },
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.start,
        shrinkWrap: true,
        itemCount: defaultRanobeModel.genres?.keys.length,
      ),
    );
  }

  Container genreCard(genreTitle, href) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width! * 0.0075, vertical: height! * 0.001),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff3D60D7), width: 1.25)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width! * 0.02, vertical: height! * 0.003),
        child: AutoSizeText(genreTitle ?? "",
            presetFontSizes: const [14],
            style: TextStyle(
              color: themeData.colorScheme.onPrimary,
            )),
      ),
    );
  }
}
