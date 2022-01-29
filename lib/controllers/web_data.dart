import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/school_life_item.dart';
import '../models/substitution_table.dart';
import '../models/web_data_exception.dart';
import '../models/news_item.dart';
import '../models/feedback_item.dart';
import '../models/teacher.dart';
import './local_data.dart';

class WebData extends GetxController {
  //HTML Data
  List<SubstitutionTable> substitutionTables = [];
  List<NewsItem> news = [];
  DateTime latestUpdate = DateTime.now();
  String ticker = "";

  //Database Data
  List<SchoolLifeItem> schoolLifeItems = [];
  List<Teacher> teachers = [];

  Future<void> fetchData() async {
    await fetchHtml();
    await fetchDatabse();
    update();
  }

//########################################################################
//#                           Fetching Data                              #
//########################################################################

  Future<void> fetchHtml() async {
    final settings = Get.find<LocalData>().settings;
    final basicAuth = 'Basic ' +
        base64Encode(utf8.encode("${settings.username}:${settings.password}"));
    final url = Uri.parse(
      "https://schule-infoportal.de/infoscreen/?type=student&days=5&news=1&absent=&absent2=1",
    );
    final response = await http.get(url, headers: {"authorization": basicAuth});

    final statusCode = response.statusCode;
    final htmlData = response.body;

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

    final document = html.parse(response.body);
    var elements = document.getElementsByClassName("daily_table");
    substitutionTables = parseSubstitutions(elements);
    elements = document.getElementsByClassName("ticker-wrap_ende");
    if (elements.isNotEmpty) {
      ticker = parseTicker(elements[0]);
    }
    elements = document.getElementsByClassName("text_8pt");
    latestUpdate = parseLatestUpdate(elements[0]) ?? DateTime.now();
    var element = document.getElementById("news_container");
    news = parseNews(element);
  }

  Future<void> fetchDatabse() async {
    final database = FirebaseDatabase.instance.reference();
    final snapshot = await database.get();
    schoolLifeItems = parseSchoolLife(snapshot);
    teachers = parseTeachers(snapshot);
  }

//########################################################################
//#                              HTML Parse                              #
//########################################################################

  List<SubstitutionTable> parseSubstitutions(List<Element> elements) {
    List<SubstitutionTable> list = [];

    for (var element in elements) {
      List<SubstitutionTableRow> rows = [];
      final rowElements = element.getElementsByTagName("tr");
      String group = "";
      List<String> groups = [];
      for (int i = 3; i < rowElements.length; i++) {
        final fields = rowElements[i].getElementsByTagName("td");

        if (fields.length == 6) {
          final course = fields[0].text.isNotEmpty ? fields[0].text : "";
          if (course != String.fromCharCode(160)) {
            if (groups.contains(course)) {
              break;
            }
            group = course;
          }
          if (!groups.contains(group)) {
            groups.add(group);
          }
          rows.add(SubstitutionTableRow(
            course: course,
            period: fields[1].text.isNotEmpty ? fields[1].text : "",
            absent: fields[2].text.isNotEmpty ? fields[2].text : "",
            substitute: fields[3].text.isNotEmpty ? fields[3].text : "",
            room: fields[4].text.isNotEmpty ? fields[4].text : "",
            info: fields[5].text.isNotEmpty ? fields[5].text : "",
            group: group,
          ));
        }
      }

      list.add(SubstitutionTable(
        rows: rows,
        date: parseDate(rowElements[0].text) ?? DateTime(2000),
        groups: groups,
      ));
    }
    return list;
  }

  List<NewsItem> parseNews(Element? element) {
    List<NewsItem> newsItems = [];
    if (element != null) {
      final news = element.getElementsByTagName("div");
      newsItems = news.map((item) {
        List<Element> headlines = item.getElementsByTagName("p");
        Element content = item.getElementsByTagName("span")[0];
        return NewsItem(
          headline: headlines[0].text.trim(),
          subheadline: headlines.length > 1 ? headlines[1].text.trim() : "",
          content:
              content.text.isNotEmpty ? formatContent(content.innerHtml) : "",
        );
      }).toList();
    }
    return newsItems;
  }

  String parseTicker(Element element) {
    List<Element> items = element.getElementsByClassName("ticker__item");
    String ticker = "";
    if (items.isNotEmpty) {
      items.forEach((element) {
        ticker = ticker + (element.text.trim()) + ' ';
      });
    }

    return ticker;
  }

  DateTime? parseLatestUpdate(Element element) {
    String text = element.text;

    RegExp regex = RegExp(r"\d\d\.\d\d\.\d\d\d\d \d\d:\d\d:\d\d");
    final match = regex.firstMatch(text);
    if (match != null) {
      final dateString = text.substring(match.start, match.end);
      final formatter = DateFormat(r"d.M.y H:m:s");
      final datetime = formatter.parse(dateString);
      return datetime;
    }
  }

//########################################################################
//#                          Parse Database                              #
//########################################################################

  List<SchoolLifeItem> parseSchoolLife(DataSnapshot data) {
    final content = data.value;

    List<SchoolLifeItem> list = [];
    if (content is Map) {
      final schoolLife = content["schoolLife"];
      schoolLife.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);
        list.add(SchoolLifeItem.fromJson(item));
      });
      list.sort((a, b) {
        return b.datetime.millisecondsSinceEpoch
            .compareTo(a.datetime.millisecondsSinceEpoch);
      });
    }
    return list;
  }

  List<Teacher> parseTeachers(DataSnapshot data) {
    final content = data.value;

    List<Teacher> list = [];

    if (content is Map) {
      final teachers = content["teachers"];
      if (teachers is Map) {
        teachers.forEach((key, value) {
          list.add(Teacher(key, value));
        });
      }
    }
    list.sort((a, b) {
      return a.abbreviation.compareTo(b.abbreviation);
    });
    return list;
  }

//########################################################################
//#                           String format                              #
//########################################################################

  String formatContent(String text) {
    if (text.isNotEmpty) {
      text = text
          .replaceAll("<br>", "\n")
          .replaceAll("<br />", "\n")
          .replaceAll("&gt;", ">")
          .replaceAll("&lt;", "<")
          .replaceAll("&quot;", "\"")
          .replaceAll("&amp;", "&")
          .replaceAll("&nbsp;", "")
          .replaceAll("\n\n---\n\n", "\n---\n")
          .trim();
      if (text.isNotEmpty &&
          text.substring(text.length - 3, text.length) == "---") {
        text = text.substring(0, text.length - 3).trim();
      }
    }
    return text;
  }

  Future<void> submitFeedback(FeedbackItem item) async {
    final database = FirebaseDatabase.instance.reference();
    final feedback = database.child("feedback");
    final hash = DateTime.now().toString().hashCode.toString();
    return feedback.update({
      hash: {
        "name": item.name.isEmpty ? null : item.name,
        "email": item.email.isEmpty ? null : item.email,
        "message": item.message,
      }
    });
  }
}

DateTime? parseDate(String text) {
  RegExp regex = RegExp(r"\d\d\.\d\d\.\d\d\d\d");
  final match = regex.firstMatch(text);
  if (match != null) {
    final dateString = text.substring(match.start, match.end);
    final formatter = DateFormat(r"d.M.y");
    return formatter.parse(dateString);
  }
}
