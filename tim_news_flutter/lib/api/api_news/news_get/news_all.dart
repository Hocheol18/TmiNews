import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/api/dio.dart';
import 'package:tim_news_flutter/user/secure_storage.dart';

part 'news_all.g.dart';

@Riverpod(keepAlive: true)
NewsRepository newsRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return NewsRepository(dio: dio, storage: storage);
}

class NewsRepository {
  NewsRepository({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;

  Future<Response> newsFetch(String category, int offset) async {
    final String? accessToken = await storage.readAccessToken();

    return await dio.get('http://${dotenv.env['LOCAL_API_URL']}/news/list',
        queryParameters: {"category" : category, "limit" : "15", "offset" : offset},
        options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              "Content-Type": "application/json",
            }
        )
    );
  }
}