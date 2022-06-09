import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ranobe_reader/models/ranobeModel.dart';
import 'package:ranobe_reader/screens/listOfRanobeScreen/components/cardOfListRanobe.dart';

class listOfRanobeScreen extends StatefulWidget {
  Function(String param) function;
  String param;

  listOfRanobeScreen({required this.function, required this.param, Key? key})
      : super(key: key);

  @override
  State<listOfRanobeScreen> createState() =>
      _ListOfRanobeScreenState(function: function, param: param);
}

class _ListOfRanobeScreenState extends State<listOfRanobeScreen> {
  final Function(String param) function;
  final String param;
  List<Color>? colorsOfRatingList = [];
  Map<String, String> mapOfRanobeTitleAndHref = {};
  late double width;
  late double height;

  _ListOfRanobeScreenState({required this.function, required this.param});

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  Container buildBody() {
    return Container(
        width: width,
        height: height,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: mapOfRanobeTitleAndHref.keys.length,
            itemBuilder: (context, index) => CardOfListRanobe(
                  title: mapOfRanobeTitleAndHref.keys.elementAt(index),
                  href: mapOfRanobeTitleAndHref[
                      mapOfRanobeTitleAndHref.keys.elementAt(index)],
                  rating: index + 1,
                  color: colorsOfRatingList![index],
                )));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        color: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_sharp),
      ),
    );
  }

  void initInfo() {
    for (int i = 0; i < 100; i++) {
      colorsOfRatingList?.add(
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9),
      );
    }
    function(param).then((value) {
      setState(() {
        mapOfRanobeTitleAndHref = value;
      });
    });
  }
}
