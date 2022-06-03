enum ArticleElementType { HEADER, SUBHEADER, CONTENT_HEADER, CONTENT, IMAGE }

class ArticleElement {
  final ArticleElementType type;
  final String data;
  final String author;
  final String optionalData;
  final bool dark;
  const ArticleElement(this.type, this.data, this.optionalData, this.author, this.dark);

  factory ArticleElement.fromJson(Map<String, dynamic> json) {
    return ArticleElement(
      ArticleElementType.values[json["type"] as int],
      json["data"] as String,
      json.containsKey("optionalData") ? json["optionalData"] as String : "",
      json.containsKey("author") ? json["author"] as String : "",
      json.containsKey("dark") ? json["dark"] as bool : false,
    );
  }
}
