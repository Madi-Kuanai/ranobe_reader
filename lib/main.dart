/*
* {Madi Kuanai}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ranobe_reader/screens/MainScreen/MainScreen.dart';
import 'package:ranobe_reader/settings/myThemes.dart';
import 'package:ranobe_reader/settings/preferenceService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: MyTheme.lightTheme,
              darkTheme: MyTheme.darkTheme,
              home: const SafeArea(
                child: MainScreen(),
              ));
        });
  }
}
