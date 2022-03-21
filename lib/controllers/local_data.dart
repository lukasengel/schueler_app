import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exceptions/local_data_exception.dart';
import '../models/settings.dart';
import '../models/subscribe_operation.dart';

class LocalData extends GetxController {
  String? error;
  late Settings settings;
  late Map<String, Map<String, String>> translations;
  late RxList<SubscribeOperation> enqueuedOperations;

  Future<void> initialize() async {
    translations = await parseTranslations();
    settings = await parseSettings();
    enqueuedOperations = await parseOperations();
  }

//########################################################################
//#                            Translations                              #
//########################################################################
  Future<Map<String, Map<String, String>>> parseTranslations() async {
    try {
      Map<String, Map<String, String>> map = {};
      String data = await rootBundle.loadString("lang/languages.json");
      List<dynamic> availibleLangs = json.decode(data);
      for (String languageCode in availibleLangs) {
        String jsonData =
            await rootBundle.loadString("lang/$languageCode.json");
        Map<String, dynamic> languageData = json.decode(jsonData);
        Map<String, String> language = languageData.map((key, value) {
          return MapEntry(key, value.toString());
        });
        map.addAll({languageCode: language});
      }
      return map;
    } catch (e) {
      throw LocalDataException.languageParseError(e.toString());
    }
  }

//########################################################################
//#                              Settings                                #
//########################################################################
  Future<Settings> parseSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Settings(
        username: prefs.getString("username") ?? "",
        password: prefs.getString("password") ?? "",
        filters: json.decode(prefs.getString("filters") ??
            """{"5": true,"6": true,"7": true,"8": true,"9": true,"10": true,"11": true,"12": true,"i": true,"Wku": true,"Fku": true,"OGTS": true,"GGTS": true,"misc": true}"""),
        notifications: prefs.getStringList("notifications") ?? [],
        reversedNews: prefs.getBool("reversedNews") ?? true,
        reversedSmv: prefs.getBool("reversedSmv") ?? true,
        dailyNotifications: prefs.getBool("dailyNotifications") ?? false,
        smvNotifications: prefs.getBool("smvNotifications") ?? false,
        broadcastNotifications:
            prefs.getBool("broadcastNotifications") ?? false,
        forceGerman: prefs.getBool("forceGerman") ?? false,
        selectedTheme: ColorMode.values[prefs.getInt("selectedTheme") ?? 1],
      );
    } catch (e) {
      throw LocalDataException.settingsParseError(e.toString());
    }
  }

  Future<void> writeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", settings.username);
      await prefs.setString("password", settings.password);
      await prefs.setString("filters", json.encode(settings.filters));
      await prefs.setStringList("notifications", settings.notifications);
      await prefs.setBool("reversedNews", settings.reversedNews);
      await prefs.setBool("reversedSmv", settings.reversedSmv);
      await prefs.setBool("dailyNotifications", settings.dailyNotifications);
      await prefs.setBool("smvNotifications", settings.smvNotifications);
      await prefs.setBool(
          "broadcastNotifications", settings.broadcastNotifications);
      await prefs.setBool("forceGerman", settings.forceGerman);
      await prefs.setInt("selectedTheme", settings.selectedTheme.index);
    } catch (e) {
      throw LocalDataException.settingsWriteError(e.toString());
    }
    update();
  }

//########################################################################
//#                             Operations                               #
//########################################################################
  Future<RxList<SubscribeOperation>> parseOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList("enqueuedOperations") ?? [];
      List<SubscribeOperation> operations = [];
      list.forEach((element) {
        operations.add(SubscribeOperation.fromJson(json.decode(element)));
      });
      return operations.obs;
    } catch (e) {
      throw LocalDataException.operationsParseError(e.toString());
    }
  }

  Future<void> writeOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> list = [];
      enqueuedOperations.forEach((element) {
        list.add(json.encode(element.toJson()));
      });
      await prefs.setStringList("enqueuedOperations", list);
    } catch (e) {
      throw LocalDataException.operationsWriteError(e.toString());
    }
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
      settings = await parseSettings();
    } catch (e) {
      throw LocalDataException.clearSettingsError(e.toString());
    }
  }

  ThemeMode get getThemeMode {
    switch (settings.selectedTheme.index) {
      case 0:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
