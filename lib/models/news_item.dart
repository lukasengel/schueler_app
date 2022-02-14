class NewsItem {
  String headline;
  String subheadline;
  String content;

  NewsItem({
    required this.headline,
    required this.subheadline,
    required this.content,
  });

  @override
  String toString() {
    return "$headline-$subheadline-$content";
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      headline: json["headline"] ?? "",
      subheadline: json["subheadline"] ?? "",
      content: json["content"] ?? "",
    );
  }
}
