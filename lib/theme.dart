import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primarySwatch: redAccent,
    scaffoldBackgroundColor: const Color(0xFFEFEFF4),
    fontFamily: "Montserrat",
    hintColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[300],
    appBarTheme: const AppBarTheme(
      backgroundColor: redAccent,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        // color: redAccent,
        fontFamily: "Montserrat",
        fontSize: 25,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusColor: redAccent,
      fillColor: Colors.grey.shade100,
      filled: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: redAccent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (_) => const TextStyle(fontSize: 25, fontFamily: "Montserrat"),
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
      headline1: const TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontFamily: "LobsterTwo",
      ),
      headline2: const TextStyle(
        fontSize: 16,
      ),
      headline3: TextStyle(
        fontSize: 22,
        color: Colors.grey.shade800,
      ),
      headline6: const TextStyle(
        color: redAccent,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 1,
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
    indicatorColor: Colors.grey.shade600,
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: redAccent,
    hintColor: Colors.grey,
    cardColor: const Color(0xff1c1c1e),
    canvasColor: Colors.grey[800],
    errorColor: Colors.red[500],
    fontFamily: "Montserrat",
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1c1c1e),
      foregroundColor: redAccent,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: redAccent,
        fontFamily: "Montserrat",
        fontSize: 25,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: redAccent,
      suffixStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
      foregroundColor: redAccent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff1c1c1e),
      unselectedItemColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (_) => const TextStyle(fontSize: 25, fontFamily: "Montserrat"),
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
    textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 50,
          color: Colors.white,
          fontFamily: "LobsterTwo",
        ),
        headline2: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        headline3: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        headline6: TextStyle(
          color: redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 1,
        ),
        bodyText1: TextStyle(color: Colors.white, fontSize: 14),
        //##########################
        //#     News Container     #
        //##########################
        headline4: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: "LobsterTwo",
        ),
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 18,
          height: 1,
        ),
        caption: TextStyle(
          color: Colors.white,
          fontSize: 16,
        )),
    indicatorColor: Colors.white,
  );
}

//const redAccent = Colors.indigo;

const redAccent = MaterialColor(0xfffa2244, {
  50: Color(0xfffa2244),
  100: Color(0xfffa2244),
  200: Color(0xfffa2244),
  300: Color(0xfffa2244),
  400: Color(0xfffa2244),
  500: Color(0xfffa2244),
  600: Color(0xfffa2244),
  700: Color(0xfffa2244),
  800: Color(0xfffa2244),
  900: Color(0xfffa2244),
});
