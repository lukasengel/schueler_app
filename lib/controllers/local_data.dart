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
        reversed: prefs.getBool("reversed") ?? true,
        reversedSchoolLife: prefs.getBool("reversedSchoolLife") ?? true,
        filters: json
            .decode(prefs.getString("filters") ?? Settings.defaultFiltersStr),
        dailyNotifications: prefs.getBool("dailyNotifications") ?? false,
        smvNotifications: prefs.getBool("smvNotifications") ?? false,
        notifications: prefs.getStringList("notifications") ?? [],
        forceGerman: prefs.getBool("forceGerman") ?? false,
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
      await prefs.setBool("reversed", settings.reversed);
      await prefs.setBool("reversedSchoolLife", settings.reversedSchoolLife);
      await prefs.setString("filters", json.encode(settings.filters));
      await prefs.setBool("dailyNotifications", settings.dailyNotifications);
      await prefs.setBool("smvNotifications", settings.smvNotifications);
      await prefs.setStringList("notifications", settings.notifications);
      await prefs.setBool("forceGerman", settings.forceGerman);
    } catch (e) {
      error = e.toString();
    }
    update();
  }

  Future<void> toggleFilter(String key) async {
    if (settings.filters.containsKey(key)) {
      settings.filters[key] = !settings.filters[key]!;
      await writeSettings();
    }
  }

  Future<void> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      settings = Settings.empty();
    } catch (e) {
      error = e.toString();
    }
  }
}
