import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:get/get.dart';

import '../models/web_data_exception.dart';
import './local_data.dart';

enum AuthState { loggedOn, loggedOff }

class WebData extends GetxController {
  List<List<List<String>>> dailyTables = [];
  List<List<List<int>>> groups = [];
  List<List<String>> news = [];
  List<List<String>> newsInverted = [];
  String ticker = "";
  String latestUpdate = "";

  String htmlData = "";
  String error = "";

  AuthState authState = AuthState.loggedOff;

  Future<void> initialize() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    error = "";
    try {
      final localData = Get.find<LocalData>();
      if (localData.settings.username.isEmpty ||
          localData.settings.password.isEmpty) {
        throw (WebDataException.emptyCredentials());
      }
      final username = localData.settings.username;
      final password = localData.settings.password;
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final url = Uri.parse(
          "https://schule-infoportal.de/infoscreen/?type=student&refresh=100&fontsize=16&days=5&theme=light&news=1&absent=&absent2=1");
      final response = await http.get(
        url,
        headers: {
          "authorization": basicAuth,
          "Access-Control-Allow-Origin": "*",
        },
      );

      int statusCode = response.statusCode;
      htmlData = response.body;

      if (htmlData.isEmpty || statusCode == 0) {
        throw (WebDataException.noData());
      }
      if (statusCode >= 226 || statusCode <= 103) {
        switch (statusCode) {
          case 401:
            throw (WebDataException.unauthorized());
          case 403:
            throw (WebDataException.forbidden());
          case 404:
            throw (WebDataException.notFound());
          default:
            throw (WebDataException.unknownHttpError(statusCode));
        }
      }
      setAuthState(true);
      parseHtml();
    } catch (e) {
      error = e.toString();
    }
    update();
  }

  void setAuthState(bool value) {
    if (value) {
      authState = AuthState.loggedOn;
    } else {
      authState = AuthState.loggedOff;
    }
    update();
  }

  void parseHtml() {
    final document = html.parse(htmlData);
    var elements = document.getElementsByClassName("text_8pt");
    latestUpdate = parseLatestUpdate(elements[0]);
    elements = document.getElementsByClassName("ticker-wrap_ende");
    ticker = parseTickerItems(elements[0]);
    var element = document.getElementById("news_container");
    news = parseNews(element);
    newsInverted = news.reversed.toList();
    elements = document.getElementsByClassName("daily_table");
    dailyTables = parseDailyTables(elements);
    groups = groupDailyTables(dailyTables);
  }

  String parseLatestUpdate(Element element) {
    String text = element.text;
    RegExp regex = RegExp(
      r"Letzte\sAktualisierung:\s([0-9]+(\.[0-9]+)+)\s([0-9]+(:[0-9]+)+)",
    );
    RegExpMatch? match = regex.firstMatch(text);
    return match != null ? text.substring(match.start, match.end) : "";
  }

  String parseTickerItems(Element element) {
    List<Element> items = element.getElementsByClassName("ticker__item");
    String string = "";
    items.forEach((element) {
      string = string + (element.text.trim()) + ' ';
    });
    return string;
  }

  List<List<String>> parseNews(Element? element) {
    if (element != null) {
      final newsContainer = element.getElementsByTagName("div");
      return newsContainer.map((e) {
        return parseNewsList(e);
      }).toList();
    } else {
      return [];
    }
  }

  List<String> parseNewsList(Element element) {
    List<Element> headlines = element.getElementsByTagName("p");
    Element content = element.getElementsByTagName("span")[0];
    String cleanContent = removeHtmlTags(content.innerHtml);
    return [
      ...headlines.map((e) => e.text),
      cleanContent,
    ];
  }

  List<List<List<String>>> parseDailyTables(List<Element> elements) {
    return elements.map((e) => parseDailyTable(e)).toList();
  }

  List<List<String>> parseDailyTable(Element element) {
    List<Element> rows = element.getElementsByTagName("tr");
    List<List<String>> content = rows.map((e) {
      List<Element> fields = e.getElementsByTagName("td");
      return fields.map((ee) {
        return ee.text.isEmpty ? "" : ee.text;
      }).toList();
    }).toList();
    return content;
  }

  List<List<List<int>>> groupDailyTables(List<List<List<String>>> tables) {
    List<List<List<int>>> grouped = [];
    tables.forEach((element) {
      int groupIndex = 0;
      List<List<int>> groups = [];
      for (int i = 3; i < element.length; i++) {
        if (element[i].first == String.fromCharCode(160) && groups.isNotEmpty) {
          groups[groupIndex].add(i);
        } else {
          groups.add([i]);
          groupIndex = groups.length - 1;
        }
      }
      grouped.add(groups);
    });
    return grouped;
  }

  String removeHtmlTags(String raw) {
    String clean = raw
        .replaceAll("<br>", "\n")
        .replaceAll("<br />", "\n")
        .replaceAll("&gt;", ">")
        .replaceAll("&lt;", "<")
        .replaceAll("&quot;", "\"")
        .replaceAll("&amp;", "&")
        .replaceAll("&nbsp;", "")
        .trim();
    return clean;
  }
}
