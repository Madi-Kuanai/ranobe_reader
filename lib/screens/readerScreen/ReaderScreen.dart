import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:internet_file/internet_file.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../const.dart';
import '../../settings/myThemes.dart';

class EpubViewer extends StatefulWidget {
  final int id;
  final int domainId; //domainId - id of site {
  //ranobeHub id = 0
  //ranobeMe id = 1
  // }

  const EpubViewer(this.id, this.domainId, {Key? key}) : super(key: key);

  @override
  State<EpubViewer> createState() => _EpubViewerState();
}

class _EpubViewerState extends State<EpubViewer> {
  EpubController? _epubController;
  late ThemeData themeData;
  late double width, height;
  int lastPercent = 0;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return null != _epubController
        ? SafeArea(
            child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: themeData.colorScheme.onPrimary,
              ),
              title: EpubViewActualChapter(
                  controller: _epubController!,
                  builder: (chapterValue) {
                    _epubController?.document.then((value) {});
                    return Text(
                      chapterValue?.chapter?.Title
                              ?.replaceAll('\n', '')
                              .trim() ??
                          '',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: themeData.colorScheme.onPrimary),
                    );
                  }),
              actions: <Widget>[
                Switch.adaptive(
                  activeColor: Colors.black,
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(value);
                  },
                  inactiveTrackColor: Colors.black,
                  activeTrackColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  splashRadius: 0,
                  activeThumbImage:
                      const AssetImage(Const.pathToImages + "nightMode.png"),
                  inactiveThumbImage:
                      const AssetImage(Const.pathToImages + "lightMode.png"),
                ),
                IconButton(
                  icon: const Icon(Icons.save_alt),
                  color: themeData.colorScheme.onPrimary,
                  onPressed: () => _showCurrentEpubCfi(context),
                ),
              ],
            ),
            drawer: Drawer(
              backgroundColor: themeData.scaffoldBackgroundColor,
              child: EpubViewTableOfContents(
                controller: _epubController!,
                itemBuilder: (context, index, chapter, itemCount) =>
                    GestureDetector(
                  onTap: () {
                    _epubController?.scrollTo(index: chapter.startIndex);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    width: width * 0.6,
                    height: height * 0.075,
                    child: Text(
                      chapter.title!,
                      style: TextStyle(color: themeData.colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              child: GestureDetector(
                child: EpubView(
                  onDocumentLoaded: (document) {
                    print(document.CoverImage);
                  },
                  builders: EpubViewBuilders<DefaultBuilderOptions>(
                    options: DefaultBuilderOptions(
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    chapterDividerBuilder: (_) => const Divider(height: 1),
                    loaderBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    errorBuilder: (_, error) => Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),
                  ),
                  controller: _epubController!,
                ),
                onTap: () {},
              ),
            ),
          ))
        : Container(
            width: width,
            height: height,
            color: themeData.scaffoldBackgroundColor,
            child: Center(
              child: CircularPercentIndicator(
                radius: width * 0.2,
                lineWidth: width * 0.025,
                linearGradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.cyanAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                percent: (lastPercent * 5) / 100,
                center: AutoSizeText(
                  (lastPercent * 5).toString() + "%",
                  presetFontSizes: const [
                    20,
                    16,
                  ],
                  style: TextStyle(color: themeData.colorScheme.onPrimary),
                ),
              ),
              // child: Lottie.asset(
              //   "assets/animations/loadingAnimation.json",
              //   width: width * 0.5,
              //   height: height * 0.6,
              // ),
            ),
          );
  }

  void _showCurrentEpubCfi(context) {
    final cfi = _epubController!.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Сохранить прогресс ?'),
          action: SnackBarAction(
            label: "Да",
            onPressed: () {
              _epubController!.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }

  void init() async {
    var doc = await InternetFile.get(
      widget.domainId == 0
          ? 'https://ranobehub.org/ranobe/${widget.id}/download.epub_img'
          : "https://ranobe.me/section_fictofile_download.php?id=${widget.id}&format=epub",
      process: (percentage) {
        if (percentage.toInt() ~/ 5 != lastPercent) {
          setState(() {
            lastPercent = percentage.toInt() ~/ 5;
          });
          print(lastPercent);
        }
      },
    );

    if (mounted) {
      setState(() {
        if (mounted) {
          _epubController = EpubController(
            document: EpubDocument.openData(doc),
          );
        }
      });
    }
  }
}
