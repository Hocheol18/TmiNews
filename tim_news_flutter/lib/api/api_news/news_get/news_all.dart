import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/api/dio.dart';
import 'package:tim_news_flutter/user/secure_storage.dart';

import '../../../news/models/news_pagination_model.dart';
import '../../../news/pagination/pagination_result.dart';
import '../../../news/pagination/pagination_run_catching_exception.dart';
import '../../../news/pagination/pagination_state.dart';

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

  //TODO : CustomExceptions
  Future<Result<Pagination<NewsPaginationModel>>> newsFetch(String category, int idx, int limit) async {
    final String? accessToken = await storage.readAccessToken();

    return runCatchingExceptions(() async {
      final resp = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/news/list',
        queryParameters: {"category": category, "offset": idx, "limit": limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return Pagination.fromJson(
        resp.data,
            (json) => NewsPaginationModel.fromJson(json as Map<String, dynamic>),
      );
    });
  }
}
