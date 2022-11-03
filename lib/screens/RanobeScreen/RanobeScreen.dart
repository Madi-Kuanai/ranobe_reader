// ignore_for_file: must_be_immutable

import 'dart:ui';
import 'package:html/parser.dart';
import "package:http/http.dart" as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:ranobe_reader/components.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';

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
            leading: const Icon(null),
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
                              ),
                              Container(
                                width: width * 0.6,
                                height: height * 0.15,
                                child: GenreListWidget(href: model.href),
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
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeData.primaryColor,
                                  border: Border.all(
                                      color: themeData.colorScheme.onPrimary,
                                      width: 0.5)),
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

class GenreListWidget extends StatefulWidget {
  final String href;

  const GenreListWidget({required this.href, Key? key}) : super(key: key);

  @override
  State<GenreListWidget> createState() => _GenreListWidgetState();
}

class _GenreListWidgetState extends State<GenreListWidget> {
  List<String> genres = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.4,
        mainAxisSpacing: width * 0.02,
        crossAxisSpacing: width * 0.02,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return GenreWidget(genreTitle: genres[index]);
      },
    );
  }

  void init() async {
    http.Response response = await http.get(Uri.parse(widget.href));
    if (response.statusCode == 200) {
      var doc = parse(response.body);
      if (widget.href.contains("ranobehub")) {
        doc
            .getElementsByClassName("book-meta-value book-tags")[0]
            .getElementsByTagName("a")
            .forEach((element) {
          if (mounted) {
            setState(() {
              genres.add(element.text);
            });
          }
        });
      } else {
        doc
            .getElementById("summary_" +
                widget.href.replaceFirst("https://ranobe.me/ranobe", ""))!
            .getElementsByTagName("a")
            .forEach((element) {
          if (element.text != ">>") {
            if (mounted) {
              setState(() {
                genres.add(element.text);
              });
            }
          }
        });
      }
    }
  }
}

class GenreWidget extends StatelessWidget {
  const GenreWidget({
    Key? key,
    required this.genreTitle,
  }) : super(key: key);

  final String genreTitle;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ThemeData themeData = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      height: height * 0.04,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.0075, vertical: height * 0.001),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff3D60D7), width: 1.25)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.003),
        child: AutoSizeText(genreTitle,
            presetFontSizes: const [14],
            style: TextStyle(
              color: themeData.colorScheme.onPrimary,
            )),
      ),
    );
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

  Future<double> getImagePalette(ImageProvider image) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(image);
    return paletteGenerator.dominantColor!.color.computeLuminance();
  }
}
