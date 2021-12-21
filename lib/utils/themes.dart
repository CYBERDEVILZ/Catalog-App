import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    theme();
  }

  bool _theme = false;

  get getTheme => _theme;

  void setTheme() async {
    _theme = !_theme;
    notifyListeners();
    await SharedPreferences.getInstance()
        .then((value) => value.setBool("isItDark", _theme))
        .catchError((onError) {
      print("fetch failed");
    });
  }

  void theme() async {
    final persistData = SharedPreferences.getInstance();
    final data = await persistData;
    _theme = data.getBool("isItDark") ?? false;
    notifyListeners();
  }
}

class Themes {
  static ThemeData light() {
    return ThemeData(
      canvasColor: Colors.grey[200], // canvas bg, details second bg, appbar
      cardColor: Colors
          .white, // card bg, drawer header text, button foreground if cursor color used as bg
      buttonColor: Colors.white, // for buttons (except shopping cart icon bg)
      accentColor: Colors.black, // card text, details page text
      cursorColor: Colors.blue, //Text Theme color of the app
      dividerColor: Colors.blue[100], // for shopping cart icon
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
        brightness: Brightness.dark,
        canvasColor: const Color(0xff121212),
        cardColor: Colors.grey[900],
        buttonColor: Colors.blue[200],
        accentColor: Colors.white,
        cursorColor: Colors.blue[200],
        dividerColor: const Color(0xff03dac5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          foregroundColor: Colors.white,
          elevation: 0,
        ));
  }
}
