class NewsModel {
  String category;
  String title;
  String content;
  String date;
  List<String> images;

  NewsModel({
    this.category = '',
    this.title = '',
    this.content = '',
    this.date = '',
    this.images = const [],
});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'content': content,
      'date': date,
      'images': images,
    };
  }
}