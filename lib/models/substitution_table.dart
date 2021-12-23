class SubstitutionTable {
  final DateTime date;
  final List<SubstitutionTableRow> rows;
  const SubstitutionTable({required this.rows, required this.date});
  @override
  String toString() {
    return rows.map((row) => row.toString()).toString();
  }
}

class SubstitutionTableRow {
  final String course;
  final String period;
  final String absent;
  final String substitute;
  final String room;
  final String info;

  const SubstitutionTableRow({
    required this.course,
    required this.period,
    required this.absent,
    required this.substitute,
    required this.room,
    required this.info,
  });

  @override
  String toString() {
    return ("$course;$period;$absent;$substitute;$room;$info");
  }
}
