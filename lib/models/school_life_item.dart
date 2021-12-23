enum ItemType { EVENT, ARTICLE, ANNOUNCEMENT }

ItemType typeFromString(String string) {
  if (string == "event") {
    return ItemType.EVENT;
  } else if (string == "article") {
    return ItemType.ARTICLE;
  } else {
    return ItemType.ANNOUNCEMENT;
  }
}

String stringFromType(ItemType type) {
  if (type == ItemType.EVENT) {
    return "event";
  } else if (type == ItemType.ARTICLE) {
    return "article";
  } else {
    return "announcement";
  }
}

class SchoolLifeItem {
  String header;
  ItemType type;
  String content;
  String imageUrl;
  String hyperlink;
  DateTime datetime;
  DateTime evenTime;

  SchoolLifeItem({
    required this.header,
    required this.type,
    required this.content,
    required this.imageUrl,
    required this.hyperlink,
    required this.datetime,
    required this.evenTime,
  });

  factory SchoolLifeItem.fromJson(Map<String, dynamic> json) {
    return SchoolLifeItem(
      header: json["header"] as String,
      content: json["content"] as String,
      hyperlink:
          json.containsKey("hyperlink") ? json["hyperlink"] as String : "",
      imageUrl: json.containsKey("imageUrl") ? json["imageUrl"] as String : "",
      type: typeFromString(json["type"] as String),
      datetime: DateTime.parse(json["datetime"]),
      evenTime: json.containsKey("eventTime")
          ? DateTime.parse(json["eventTime"])
          : DateTime(2000),
    );
  }
}
