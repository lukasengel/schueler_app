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
}
