import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/user/secure_storage.dart';

part 'news_create.g.dart';

@Riverpod(keepAlive: true)
NewsCreateRepository newsCreateRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return NewsCreateRepository(dio: dio, storage: storage);
}

class NewsCreateRepository {
  NewsCreateRepository({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;

  Future<Response> newsCreate(Map<String, dynamic> code) async {
    print(code);
    final String? accessToken = await storage.readAccessToken();

    return await dio.post(
      'http://${dotenv.env['LOCAL_API_URL']}/news/preview',
      data: code,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
      ),
    );
  }
}
