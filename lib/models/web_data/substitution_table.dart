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

  factory SubstitutionTable.fromJson(Map<String, dynamic> json) {
    List<SubstitutionTableRow> rows = [];
    List<String> groups = [];

    if (json["rows"] != null) {
      json["rows"].forEach((e) {
        final item = Map<String, dynamic>.from(e);
        rows.add(SubstitutionTableRow.fromJson(item));
      });
    }

    if (json["groups"] != null) {
      groups = List<String>.from(json["groups"]);
    }

    return SubstitutionTable(
      date: DateTime.tryParse(json["date"]) ?? DateTime.now(),
      rows: rows,
      groups: groups,
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

  factory SubstitutionTableRow.fromJson(Map<String, dynamic> json) {
    return SubstitutionTableRow(
      course: json["course"] ?? "",
      period: json["period"] ?? "",
      absent: json["absent"] ?? "",
      substitute: json["substitute"] ?? "",
      room: json["room"] ?? "",
      info: json["info"] ?? "",
      group: json["group"] ?? "",
    );
  }
}
