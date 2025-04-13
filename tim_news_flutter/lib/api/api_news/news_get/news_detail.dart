import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/dio.dart';
import '../../../user/secure_storage.dart';
import '../../api_login/error/result.dart';
import '../../api_login/error/custom_exception.dart';
import '../../api_login/error/run_catching_Exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tim_news_flutter/news/models/news_detail_model.dart';

final newDetailServiceProvider = Provider<NewsDetailService>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return NewsDetailService(dio: dio, storage: storage);
});

class NewsDetailService {
  NewsDetailService({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;


  // 뉴스 상세정보 조회
  Future<Result<NewsDetail, CustomExceptions>> getNewsDetail(news_id) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/news/${news_id}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      print(response.data);
      return response.data;
    });
  }

}