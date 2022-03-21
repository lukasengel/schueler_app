import 'package:flutter/material.dart';

const primaryColor = Color(0xfffa2244);

/*
PRIMARY:            AppBar, Buttons, Switches
SECONDARY:          ScrollView Overflow
ON SECONDARY:       Icons (SchoolLifeContainer), CupertinoPicker (CoursePicker)
TERTIARY:           Replacement for CardColor
ON TERTIARY:        Inactive Buttons, SettingsInfoBox, Chevron (SettingsTile), Divider, SuffixIcons
TERTIARY CONTAINER: Search field (Abbreviations Page)
INDICATOR COLOR:    Disabled dots of Page Indicator (SubstitutionTab)

HEADLINE LARGE:     App Title (LoginScreen)
HEADLINE MEDIUM:    Header (LoginScreen)
HEADLINE SMALL:     Header (TableContainer, NewsItem)
TITLE LARGE:        AppBar
TITLE MEDIUM:       Header (SchoolLifeContainer)
TITLE SMALL:        SettingsText
LABEL SMALL:        "Tap to read more" (SchoolLifeContainer)
BODY LARGE:         Subheader (NewsItem), NewsTicker, SettingsTile
BODY MEDIUM:        Content (NewsItem, SchoolLifeContainer), Empty Pages
BODY SMALL:         TableRows (TableContainer)
*/

class AppTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: const Color(0xffefeff4),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      onSecondary: Colors.black,
      tertiary: Colors.white,
      onTertiary: Colors.grey,
      tertiaryContainer: Colors.grey.shade300,
    ),
    indicatorColor: Colors.grey.shade800,
    appBarTheme: const AppBarTheme(
      elevation: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 25, fontFamily: "Montserrat"),
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
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      focusColor: primaryColor,
    ),
    textTheme: TextTheme(
      headlineLarge: const TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontFamily: "LobsterTwo",
      ),
      headlineMedium: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 1,
      ),
      headlineSmall: const TextStyle(
        fontSize: 21,
        color: Colors.black,
        letterSpacing: 0.8,
      ),
      //LABEL-SMALL: Schulleben-Container Mehr Lesen
      labelSmall: const TextStyle(
        fontSize: 15,
        letterSpacing: 0,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
      ),
      //TITLE-SMALL: SettingsText
      titleSmall: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade800,
        fontSize: 16,
        // fontSize: 25,
      ),
      //TITLE-MEDIUM: Schulleben-Container Headline
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 25,
      ),
      //TITLE-LARGE: App-Bar
      titleLarge: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
      ),
      //BODY-LARGE: News-Ticker, News-Item Subheader
      bodyLarge: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
      //BODY-MEDIUM: News-Item-Content, Schulleben-Container Content, leere Seiten
      bodyMedium: const TextStyle(
        fontSize: 16,
      ),
      //BODY-SMALL: Vertretungsplan-Daten
      bodySmall: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      onSecondary: Colors.white,
      tertiary: const Color(0xff1c1c1e),
      onTertiary: Colors.grey,
      tertiaryContainer: Colors.grey.shade700,
    ),
    selectedRowColor: Colors.grey.shade800,
    indicatorColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Color(0xff1c1c1e),
      foregroundColor: primaryColor,
      elevation: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white,
      selectedItemColor: primaryColor,
      backgroundColor: Color(0xff1c1c1e),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
      foregroundColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 25, fontFamily: "Montserrat"),
        onPrimary: Colors.white,
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
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      focusColor: primaryColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontFamily: "LobsterTwo",
      ),
      headlineMedium: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 1,
      ),
      headlineSmall: TextStyle(
        fontSize: 21,
        color: Colors.white,
        letterSpacing: 0.8,
      ),
      labelSmall: TextStyle(
        fontSize: 15,
        letterSpacing: 0,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        fontSize: 16,
        // fontSize: 25,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 25,
      ),
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 25,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    ),
  );
}
