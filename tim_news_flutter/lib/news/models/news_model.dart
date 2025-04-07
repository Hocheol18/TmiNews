import 'dart:io';

class NewsModel {
  String category;
  String title;
  String content;
  DateTime date;
  File? images; // nullable로 선언


  NewsModel({
    this.category = '재테크',
    this.title = '',
    this.content = '',
    DateTime? date,
    this.images,
  }) : date = date ?? DateTime.now();

  NewsModel copyWith({
    String? category,
    String? title,
    String? content,
    DateTime? date,
    File? images,
  }) {
    return NewsModel(
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'images': images?.path,
    };
  }
}