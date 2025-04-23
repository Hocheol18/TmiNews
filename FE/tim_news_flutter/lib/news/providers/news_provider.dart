import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';

class NewsNotifier extends StateNotifier<NewsModel> {
  NewsNotifier() : super(NewsModel());

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setContent(String content) {
    state = state.copyWith(content: content);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void setImages(File images) {
    state = state.copyWith(images: images);
  }

  void resetData() {
    state = NewsModel();
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsModel>((ref) {
  return NewsNotifier();
});