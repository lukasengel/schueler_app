import './article.dart';

enum ItemType { EVENT, ARTICLE, ANNOUNCEMENT }

ItemType stringToType(String string) {
  switch (string) {
    case "event":
      return ItemType.EVENT;
    case "article":
      return ItemType.ARTICLE;
    default:
      return ItemType.ANNOUNCEMENT;
  }
}

class SchoolLifeItem {
  String header;
  bool dark;
  ItemType type;
  String content;
  String imageUrl;
  String imageCopyright;
  String hyperlink;
  DateTime datetime;
  DateTime eventTime;
  List<ArticleElement> articleElements;

  SchoolLifeItem({
    required this.header,
    required this.dark,
    required this.type,
    required this.content,
    required this.imageUrl,
    required this.imageCopyright,
    required this.hyperlink,
    required this.datetime,
    required this.eventTime,
    required this.articleElements,
  });

  factory SchoolLifeItem.fromJson(Map<String, dynamic> json) {
    List<ArticleElement>? articleElements = [];

    if (json.containsKey("articleElements")) {
      final elements = json["articleElements"];
      if (elements is List) {
        elements.forEach((value) {
          articleElements.add(ArticleElement.fromJson(
            Map<String, dynamic>.from(value),
          ));
        });
      }
    }

    return SchoolLifeItem(
      header: json["header"] as String,
      content: json["content"] as String,
      hyperlink:
          json.containsKey("hyperlink") ? json["hyperlink"] as String : "",
      imageUrl: json.containsKey("imageUrl") ? json["imageUrl"] as String : "",
      dark: json.containsKey("dark") ? json["dark"] as bool : false,
      type: stringToType(json["type"] as String),
      datetime: DateTime.parse(json["datetime"]),
      eventTime: json.containsKey("eventTime")
          ? DateTime.parse(json["eventTime"])
          : DateTime(2000),
      articleElements: articleElements,
      imageCopyright:
          json.containsKey("imageCopyright") ? json["imageCopyright"] : "",
    );
  }
}
