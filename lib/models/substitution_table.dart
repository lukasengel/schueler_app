import 'dart:convert';

class SubstitutionTable {
  final DateTime date;
  final List<SubstitutionTableRow> rows;
  final List<String> groups;

  const SubstitutionTable({
    required this.rows,
    required this.date,
    required this.groups,
  });
  @override
  String toString() {
    return rows.map((row) => row.toString()).toString();
  }

  static const SubstitutionTableRow header = SubstitutionTableRow(
    course: "Kl.",
    period: "Std.",
    absent: "Abw.",
    substitute: "Ver.",
    room: "Raum",
    info: "Info",
    group: "header",
  );

  List<SubstitutionTableRow> getGroup(String group) {
    List<SubstitutionTableRow> list = [];
    if (groups.contains(group)) {
      list = rows.where((row) => row.group == group).toList();
    }
    return list;
  }

  String toJson() {
    final data = {
      "date": date.toIso8601String(),
      "rows": rows.map((e) => e.toJson()).toList(),
      "groups": groups,
    };
    final json = jsonEncode(data);
    return json;
  }

  factory SubstitutionTable.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return SubstitutionTable(
      date: DateTime.tryParse(data["date"]) ?? DateTime.now(),
      rows: (data["rows"] as List)
          .map((e) => SubstitutionTableRow.fromJson(e))
          .toList(),
      groups: data["groups"],
    );
  }
}

class SubstitutionTableRow {
  final String course;
  final String period;
  final String absent;
  final String substitute;
  final String room;
  final String info;
  final String group;

  const SubstitutionTableRow({
    required this.course,
    required this.period,
    required this.absent,
    required this.substitute,
    required this.room,
    required this.info,
    required this.group,
  });

  @override
  String toString() {
    return ("$course;$period;$absent;$substitute;$room;$info;$group");
  }

  String toJson() {
    final data = {
      "course": course,
      "period": period,
      "absent": absent,
      "substitute": substitute,
      "room": room,
      "info": info,
      "group": group,
    };
    return jsonEncode(data);
  }

  factory SubstitutionTableRow.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return SubstitutionTableRow(
      course: data["course"],
      period: data["period"],
      absent: data["absent"],
      substitute: data["substitute"],
      room: data["room"],
      info: data["info"],
      group: data["group"],
    );
  }
}
