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
}
