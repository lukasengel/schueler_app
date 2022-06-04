enum ArticleElementType {
  HEADER,
  SUBHEADER,
  CONTENT_HEADER,
  CONTENT,
  IMAGE;

  factory ArticleElementType.fromString(String data) {
    switch (data) {
      case "header":
        return ArticleElementType.HEADER;
      case "subheader":
        return ArticleElementType.SUBHEADER;
      case "content_header":
        return ArticleElementType.CONTENT_HEADER;
      case "image":
        return ArticleElementType.IMAGE;
      default:
        return ArticleElementType.CONTENT;
    }
  }
}

class ArticleElement {
  final ArticleElementType type;
  final String data;
  final String imageCopyright;
  final String description;
  final bool dark;
  const ArticleElement(
      this.type, this.data, this.description, this.imageCopyright, this.dark);

  factory ArticleElement.fromJson(Map<String, dynamic> json) {
    return ArticleElement(
      ArticleElementType.fromString(json["type"] as String),
      json["data"] as String,
      json.containsKey("description") ? json["description"] as String : "",
      json.containsKey("imageCopyright")
          ? json["imageCopyright"] as String
          : "",
      json.containsKey("dark") ? json["dark"] as bool : false,
    );
  }
}
