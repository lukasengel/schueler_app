import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../models/web_data/school_life_item.dart';
import '../models/web_data/substitution_table.dart';
import '../models/web_data/news_item.dart';
import '../models/web_data/feedback_item.dart';
import '../models/web_data/teacher.dart';

class WebData extends GetxController {
  List<SubstitutionTable> substitutionTables = [];
  List<NewsItem> news = [];
  DateTime latestUpdate = DateTime.now();
  String ticker = "";

  List<SchoolLifeItem> schoolLifeItems = [];
  List<Teacher> teachers = [];

  Future<void> fetchData() async {
    await fetchDatabse();
    update();
  }

//########################################################################
//#                           Fetching Data                              #
//########################################################################

  Future<void> fetchDatabse() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.get();
    schoolLifeItems = parseSchoolLife(snapshot);
    teachers = parseTeachers(snapshot);
    news = parseNewsItems(snapshot);
    substitutionTables = parseSubstitutionTables(snapshot);
    ticker = parseTicker(snapshot);
    latestUpdate = parseLatestUpdate(snapshot);
  }

//########################################################################
//#                          Parse Database                              #
//########################################################################

  List<SubstitutionTable> parseSubstitutionTables(DataSnapshot data) {
    final content = data.value;
    List<SubstitutionTable> list = [];

    if (data.hasChild("externalData/substitutionTables") && content is Map) {
      final news = content["externalData"]["substitutionTables"];
      news.forEach((value) {
        final item = Map<String, dynamic>.from(value);
        list.add(SubstitutionTable.fromJson(item));
      });
    }

    return list;
  }

  DateTime parseLatestUpdate(DataSnapshot data) {
    final content = data.value;
    if (data.hasChild("externalData/latestUpdate") && content is Map) {
      final isoString = content["externalData"]["latestUpdate"];
      if (isoString != null) {
        return DateTime.parse(isoString);
      }
    }
    return DateTime.now();
  }

  String parseTicker(DataSnapshot data) {
    final content = data.value;
    String text = "";
    if (data.hasChild("externalData/ticker") && content is Map) {
      text = content["externalData"]["ticker"] ?? "";
    }
    return text;
  }

  List<NewsItem> parseNewsItems(DataSnapshot data) {
    final content = data.value;
    List<NewsItem> list = [];

    if (data.hasChild("externalData/news") && content is Map) {
      final news = content["externalData"]["news"];
      if (news != null && news.isNotEmpty) {
        news.forEach((value) {
          final item = Map<String, dynamic>.from(value);
          list.add(NewsItem.fromJson(item));
        });
      }
    }

    return list;
  }

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
//#                          Submit Feedback                             #
//########################################################################

  Future<void> submitFeedback(FeedbackItem item) async {
    final database = FirebaseDatabase.instance.ref();
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
