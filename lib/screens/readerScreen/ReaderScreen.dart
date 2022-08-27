import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:internet_file/internet_file.dart';
import 'package:lottie/lottie.dart';

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
  late EpubController _epubController;
  late ThemeData themeData;
  late double width, height;

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
        ? Scaffold(
            appBar: AppBar(
              title: EpubViewActualChapter(
                controller: _epubController,
                builder: (chapterValue) => Text(
                  chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ??
                      '',
                  textAlign: TextAlign.start,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.save_alt),
                  color: themeData.colorScheme.onPrimary,
                  onPressed: () => _showCurrentEpubCfi(context),
                ),
              ],
            ),
            drawer: Drawer(
              child: EpubViewTableOfContents(
                controller: _epubController,
              ),
            ),
            body: Container(
              child: GestureDetector(
                child: EpubView(
                  builders: EpubViewBuilders<DefaultBuilderOptions>(
                    options: DefaultBuilderOptions(
                      loaderSwitchDuration: Duration(seconds: 1),
                      chapterPadding: EdgeInsets.all(8),
                      paragraphPadding: EdgeInsets.symmetric(horizontal: 16),
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    chapterDividerBuilder: (_) => const Divider(),
                    loaderBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    errorBuilder: (_, error) =>
                        Center(child: Text(error.toString())),
                  ),
                  controller: _epubController,
                ),
                onTap: () {},
              ),
            ),
          )
        : Container(
            width: width,
            height: height,
            color: Colors.yellow,
            child: Lottie.asset("assets/animations/loadingAnimation.json"),
          );
  }

  void _showCurrentEpubCfi(context) {
    final cfi = _epubController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cfi),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubController.gotoEpubCfi(cfi);
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
    );

    if (!mounted) return;
    setState(() {
      _epubController = EpubController(
        document: EpubDocument.openData(doc),
      );
    });
  }
}
