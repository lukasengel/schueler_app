import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/local_data_exception.dart';
import '../models/settings.dart';

class LocalData extends GetxController {
  Settings settings = Settings.empty();
  List<Locale> supported = [];
  Map<String, Map<String, String>> translations = {};
  String error = "";

  Future<void> initialize() async {
    try {
      await parseTranslations();
      await parseSettings();
    } catch (e) {
      error = e.toString();
    }
    update();
  }

  Future<void> parseTranslations() async {
    try {
      String data = await rootBundle.loadString("lang/languages.json");
      List<dynamic> availibleLangs = json.decode(data);
      supported = availibleLangs
          .map((e) => Locale(e.substring(0, 2), e.substring(3, 5)))
          .toList();

      for (String languageCode in availibleLangs) {
        String jsonData =
            await rootBundle.loadString("lang/$languageCode.json");
        Map<String, dynamic> languageData = json.decode(jsonData);
        Map<String, String> language = languageData.map((key, value) {
          return MapEntry(key, value.toString());
        });
        translations.addAll({languageCode: language});
      }
    } catch (e) {
      throw LocalDataException.languageParseError(e.toString());
    }
  }

  Future<void> parseSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      settings = Settings(
        username: prefs.getString("username") ?? "",
        password: prefs.getString("password") ?? "",
        themeColor: prefs.getInt("themeColor") ?? 1,
        sortingAZ: prefs.getBool("sortingAZ") ?? true,
        filters: prefs.getStringList("filters") ?? [],
      );
    } catch (e) {
      throw LocalDataException.settingsParseError(e.toString());
    }
  }

  Future<void> writeSettings() async {
    error = "";
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", settings.username);
      await prefs.setString("password", settings.password);
      await prefs.setInt("themeColor", settings.themeColor);
      await prefs.setBool("sortingAZ", settings.sortingAZ);
      await prefs.setStringList("filters", settings.filters);
    } catch (e) {
      error = e.toString();
    }
    update();
  }
}
