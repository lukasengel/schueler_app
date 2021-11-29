import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primarySwatch: redAccent,
    scaffoldBackgroundColor: Colors.grey[100],
    fontFamily: "Montserrat",
    hintColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[300],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.redAccent,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.redAccent,
        fontFamily: "Montserrat",
        fontSize: 25,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusColor: Colors.redAccent,
      fillColor: Colors.grey[300],
      filled: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.redAccent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (_) => TextStyle(fontSize: 25, fontFamily: "Montserrat"),
        ),
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 50, color: Colors.grey.shade700, fontFamily: "LobsterTwo"),
      headline2: const TextStyle(
        fontSize: 16,
      ),
      headline3: TextStyle(
        fontSize: 22,
        color: Colors.grey.shade800,
      ),
      //Settings credits
      headline6: TextStyle(
        fontSize: 24,
        color: Colors.grey.shade600,
      ),
      //##########################
      //#     News Container     #
      //##########################
      headline4: const TextStyle(
          fontSize: 25, color: Colors.black, fontFamily: "LobsterTwo"),
      bodyText2: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        height: 1,
      ),
      caption: TextStyle(
        color: Colors.grey[800],
        fontSize: 16,
      ),
    ),
    errorColor: Colors.red[900],
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: redAccent,
    hintColor: Colors.grey,
    cardColor: Color(0xff1c1c1e),
    canvasColor: Colors.grey[800],
    errorColor: Colors.red[500],
    fontFamily: "Montserrat",
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1c1c1e),
      foregroundColor: Colors.redAccent,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.redAccent,
        fontFamily: "Montserrat",
        fontSize: 25,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.redAccent,
      suffixStyle: TextStyle(color: Colors.white),
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
      foregroundColor: Colors.redAccent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff1c1c1e),
      unselectedItemColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (_) => TextStyle(fontSize: 25, fontFamily: "Montserrat"),
        ),
        shape: MaterialStateProperty.resolveWith(
          (_) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    textTheme: TextTheme(
        headline1: const TextStyle(
          fontSize: 50,
          color: Colors.white,
          fontFamily: "LobsterTwo",
        ),
        headline2: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        headline3: const TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),

        //Settings credits
        headline6: TextStyle(
          fontSize: 24,
          color: Colors.grey.shade600,
        ),
        bodyText1: const TextStyle(color: Colors.white),
        //##########################
        //#     News Container     #
        //##########################
        headline4: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: "LobsterTwo",
        ),
        bodyText2: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          height: 1,
        ),
        caption: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        )),
  );
}

const redAccent = MaterialColor(0xFFFF5252, {
  50: Color(0xFFFF5252),
  100: Color(0xFFFF5252),
  200: Color(0xFFFF5252),
  300: Color(0xFFFF5252),
  400: Color(0xFFFF5252),
  500: Color(0xFFFF5252),
  600: Color(0xFFFF5252),
  700: Color(0xFFFF5252),
  800: Color(0xFFFF5252),
  900: Color(0xFFFF5252),
});
