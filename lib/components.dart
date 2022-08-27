import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class DescriptionWidget extends StatefulWidget {
  final String href;

  const DescriptionWidget({required this.href, Key? key}) : super(key: key);

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  String? description;
  var width, height;

  @override
  void initState() {
    init(widget.href.contains("ranobehub")).then((value) {
      setState(() {
        description = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      child: AutoSizeText(
        description ?? "",
        style: TextStyle(color: themeData.colorScheme.onPrimary),
        maxLines: null,
      ),
    );
  }

  Future<String?> init(bool isRanobeHub) async {
    var response = await http.get(Uri.parse(widget.href));
    if (response.statusCode == 200) {
      var document = parse(response.body);

      return isRanobeHub
          ? document.getElementsByClassName("book-description__text")[0].text
          : document
              .getElementById(
                  "summary_${widget.href.replaceFirst("https://ranobe.me/ranobe", "")}")!
              .text;
    }
  }
}

class FavouriteWidget extends StatefulWidget {
  final String name;

  const FavouriteWidget({required this.name, Key? key}) : super(key: key);

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool _isFavourite = false;
  late Box box;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.2,
      height: height * 0.1,
      child: IconButton(
          onPressed: () {
            deleteAddFromFavourite();
          },
          icon: Icon(
            !_isFavourite ? Icons.bookmark_border : Icons.bookmark,
            size: width * 0.075,
            color: Colors.white54,
          )),
    );
  }

  void deleteAddFromFavourite() {
    _isFavourite ? box.delete(widget.name) : box.put(widget.name, null);
    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  void init() async {
    box = await Hive.openBox('favourites');
    if (box.containsKey(widget.name)) {
      if (mounted) {
        setState(() {
          _isFavourite = true;
        });
      }
    }
  }
}
