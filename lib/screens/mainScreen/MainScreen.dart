import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ranobe_reader/screens/downloadScreen/DownloadScreen.dart';
import 'package:ranobe_reader/screens/exploreScreen/ExploreScreen.dart';
import 'package:ranobe_reader/screens/favouriteScreen/FavouriteScreen.dart';
import 'package:ranobe_reader/screens/homeScreen/HomeScreen.dart';
import 'package:ranobe_reader/screens/settingScreen/SettingScreen.dart';
import 'package:ranobe_reader/settings/myThemes.dart';
import 'package:ranobe_reader/settings/preferenceService.dart';

import '../../consts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indexOfScreen = 0;
  ThemeData? theme;
  double? width;
  double? height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme?.scaffoldBackgroundColor,
      body: SafeArea(
        child: _indexOfScreen == 0
            ? const HomeScreen()
            : _indexOfScreen == 1
                ? const ExploreScreen()
                : _indexOfScreen == 2
                    ? const FavouriteScreen()
                    : _indexOfScreen == 3
                        ? const DownloadScreen()
                        : const SettingScreen(),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme?.appBarTheme.backgroundColor,
      title: SizedBox(
        width: width! * 0.5,
        child: Row(
          children: [
            Text(
              "Ranobe",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme?.colorScheme.onPrimary),
            ),
            Text(
              "HUB",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: theme?.colorScheme.onPrimary),
            )
          ],
        ),
      ),
      actions: [
        Switch.adaptive(
          activeColor: Colors.black,
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
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
        )
      ],
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: "",
          backgroundColor: theme?.bottomAppBarColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.explore,
          ),
          label: "",
          backgroundColor: theme?.bottomAppBarColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.bookmark,
          ),
          label: "",
          backgroundColor: theme?.bottomAppBarColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.download_rounded,
          ),
          label: "",
          backgroundColor: theme?.bottomAppBarColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.settings,
          ),
          label: "",
          backgroundColor: theme?.bottomAppBarColor,
        ),
      ],
      selectedItemColor: theme?.iconTheme.color,
      unselectedItemColor: const Color(0xff9FA4AA),
      onTap: (int value) {
        setState(() {
          _indexOfScreen = value;
        });
      },
      currentIndex: _indexOfScreen,
    );
  }
}
