enum ItemType { EVENT, ARTICLE, ANNOUNCEMENT }

ItemType typeFromString(String string) {
  switch (string) {
    case "event":
      return ItemType.EVENT;
    case "article":
      return ItemType.ARTICLE;
    default:
      return ItemType.ANNOUNCEMENT;
  }
}

String stringFromType(ItemType type) {
  switch (type) {
    case ItemType.EVENT:
      return "event";
    case ItemType.ARTICLE:
      return "article";
    default:
      return "announcement";
  }
}

class SchoolLifeItem {
  String header;
  bool dark;
  ItemType type;
  String content;
  String imageUrl;
  String hyperlink;
  DateTime datetime;
  DateTime eventTime;

  SchoolLifeItem({
    required this.header,
    required this.dark,
    required this.type,
    required this.content,
    required this.imageUrl,
    required this.hyperlink,
    required this.datetime,
    required this.eventTime,
  });

  factory SchoolLifeItem.fromJson(Map<String, dynamic> json) {
    return SchoolLifeItem(
      header: json["header"] as String,
      content: json["content"] as String,
      hyperlink:
          json.containsKey("hyperlink") ? json["hyperlink"] as String : "",
      imageUrl: json.containsKey("imageUrl") ? json["imageUrl"] as String : "",
      dark: json.containsKey("dark") ? json["dark"] as bool : false,
      type: typeFromString(json["type"] as String),
      datetime: DateTime.parse(json["datetime"]),
      eventTime: json.containsKey("eventTime")
          ? DateTime.parse(json["eventTime"])
          : DateTime(2000),
    );
  }
}
