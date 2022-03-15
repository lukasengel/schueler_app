import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primarySwatch: redAccent,
    scaffoldBackgroundColor: const Color(0xFFEFEFF4),
    fontFamily: "Montserrat",
    hintColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: const Color(0xFFEFEFF4),
    appBarTheme: const AppBarTheme(
      backgroundColor: redAccent,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: "Montserrat",
        fontSize: 25,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      focusColor: redAccent,
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
        splashFactory: InkRipple.splashFactory,
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
        fontSize: 14,
      ),
      headline3: TextStyle(
        fontSize: 22,
        color: Colors.grey.shade800,
      ),
      headline6: const TextStyle(
        color: redAccent,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 1,
      ),
      headline4: const TextStyle(
        fontSize: 21,
        color: Colors.black,
        letterSpacing: 0.8,
      ),
      bodyText2: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        // height: 1,
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
    canvasColor: Colors.grey[900],
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
        fontWeight: FontWeight.w400,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: redAccent,
      border: InputBorder.none,
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
          fontSize: 14,
        ),
        headline3: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        headline6: TextStyle(
          color: redAccent,
          fontWeight: FontWeight.w400,
          fontSize: 24,
          letterSpacing: 1,
        ),
        bodyText1: TextStyle(color: Colors.white, fontSize: 14),
        //##########################
        //#     News Container     #
        //##########################
        headline4: TextStyle(
          fontSize: 21,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 18,
          // height: 1,
        ),
        caption: TextStyle(
          color: Colors.white,
          fontSize: 16,
        )),
    indicatorColor: Colors.white,
  );
}

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
