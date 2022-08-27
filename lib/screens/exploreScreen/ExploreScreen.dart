import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ranobe_reader/backend/ParseRanobe/searchRanobe.dart';
import 'package:ranobe_reader/settings/preferenceService.dart';
import '../../const.dart';
import '../../models/ranobeModel.dart';
import '../RanobeScreen/RanobeScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ThemeData? themeData;
  List<RanobeModel> listOfRanobe = [];
  late double width, height;
  List<SearchedRanobeWidget> displayedList = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    themeData = Theme.of(context);
    return listOfRanobe.isNotEmpty
        ? GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              height: height,
              width: width,
              child: Column(children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    child: InkWell(
                      highlightColor: themeData?.scaffoldBackgroundColor,
                      radius: 20,
                      child: TextField(
                        onSubmitted: (value) {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        onChanged: (value) => updateList(value),
                        style:
                            TextStyle(color: themeData?.colorScheme.onPrimary),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.deepPurple,
                            ),
                            hintText: "e.q. " + listOfRanobe.first.name + "...",
                            hintStyle: TextStyle(
                                color: PreferenceService.isDarkMode()
                                    ? Colors.white24
                                    : Colors.black45),
                            filled: true,
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: themeData!.colorScheme.onPrimary,
                                    width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: themeData!.colorScheme.onPrimary,
                                    width: 2.0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: themeData!.colorScheme.onPrimary,
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: themeData!.colorScheme.onPrimary,
                                    width: 1.0))),
                      ),
                    )),
                SizedBox(
                    width: width,
                    height: height * 0.7,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: displayedList.length,
                        itemBuilder: (context, index) => displayedList[index]))
              ]),
            ))
        : Container();
  }

  void updateList(String value) {
    setState(() {
      displayedList.clear();
      listOfRanobe
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .forEach((elem) {
        displayedList.add(SearchedRanobeWidget(elem, width, height));
      });
    });
  }

  void init() async {
    SearchRanobe.initData().then((value) {
      if (mounted) {
        setState(() {
          listOfRanobe = (value as List<RanobeModel>);
          listOfRanobe.shuffle();
        });
      }
    });
    // for (var element in data) {
    //   if (element["title"].toString().toLowerCase().contains("класс".toLowerCase())) {
    //     print(element);
    //   }
    // }
  }
}

class SearchedRanobeWidget extends StatelessWidget {
  const SearchedRanobeWidget(this.ranobeModel, this.width, this.height,
      {Key? key})
      : super(key: key);
  final double width, height;
  final RanobeModel ranobeModel;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        width: width * 0.7,
        height: height * 0.1,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RanobePage(
                    model: ranobeModel,
                  ),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: themeData.scaffoldBackgroundColor,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: getAvatar()),
              ),
              Container(
                  width: width * 0.65,
                  margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                  child: AutoSizeText(
                    ranobeModel.name,
                    presetFontSizes: const [14, 12, 10],
                    maxLines: 3,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: themeData.colorScheme.onPrimary),
                  ))
            ],
          ),
        ));
  }

  Widget getAvatar() {
    try {
      return Image.network(ranobeModel.domainLink +
          ranobeModel.coverLink.replaceAll("big", "small"));
    } catch (e) {
      return Container(
        color: Colors.black26,
      );
    }
  }
}
