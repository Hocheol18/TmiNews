import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/api_news_create/news_create/news_create.dart';


Future<Response> newsCreateSubmit(WidgetRef ref, String category, String content, String title, File? images, DateTime date) async {
  final newsFunction = ref.read(newsCreateRepositoryProvider);

  final Map<String, dynamic> data = {
    "title": title,
    "content": content,
    "category": category,
    "news_time": "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
  };

  return await newsFunction.newsCreate(data);
}

Future<Response> newsCreatePostSubmit(WidgetRef ref, String category, String content, String title, String date) async {
  final newsFunction = ref.read(newsCreateRepositoryProvider);
  
  final Map<String, String> data = {
    "title": title,
    "content": content,
    "category": category,
    "newsTime": date.substring(0, 10)
  };

  return await newsFunction.newsCreatePost(data);
}