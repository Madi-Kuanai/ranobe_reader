import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';

class RanobePage extends StatelessWidget {
  DefaultRanobeModel model;
  double? width, height;
  late ThemeData themeData;

  RanobePage({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    Color? contrastColor;
    TextStyle titleStyle =
        GoogleFonts.notoSans(color: themeData.colorScheme.onPrimary);
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const Icon(null),
            iconTheme: IconThemeData(color: themeData.scaffoldBackgroundColor),
            flexibleSpace: Stack(
              children: [
                SizedBox(
                  child: Image.network(
                    model.domainLink + model.coverLink,
                    fit: BoxFit.cover,
                  ),
                  width: width,
                  height: height! * 0.3,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 20),
                  child: Container(
                    color: themeData.scaffoldBackgroundColor.withOpacity(0.2),
                  ),
                ),
                SizedBox(
                  width: width,
                  height: height! * 0.3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width! * 0.3,
                        height: height! * 0.2,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              model.domainLink + model.coverLink,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: width! * 0.03),
                                  width: width! * 0.5,
                                  height: height! * 0.05,
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
                                      color: themeData.scaffoldBackgroundColor,
                                    ))
                              ],
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(
                            top: height! * 0.04, left: width! * 0.02),
                      )
                    ],
                  ),
                )
              ],
            ),
            expandedHeight: height! * 0.3,
          )
        ],
      ),
    ));
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
      setState(() {
        computeLuminance = value;
      });
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
