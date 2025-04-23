import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/dio.dart';
import '../../../user/secure_storage.dart';
import '../../api_login/error/result.dart';
import '../../api_login/error/custom_exception.dart';
import '../../api_login/error/run_catching_Exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  Future<Result<Map<String, dynamic>, CustomExceptions>> getNewsDetail(news_id) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/news/${news_id}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response.data;
    });
  }

  // 댓글 작성
  Future<Result<void, CustomExceptions>> createComment(news_id, comment, parentId) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      final response = await dio.post(
        'http://${dotenv.env['LOCAL_API_URL']}/news/${news_id}/reply',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "content": comment,
          "parentId": parentId
        }
      );
      print(response);
    });
  }

  // 좋아요처리
  Future<Result<void, CustomExceptions>> toggleLike(news_id, liked) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      if (liked == true) {
        await dio.delete(
            'http://${dotenv.env['LOCAL_API_URL']}/news/${news_id}/likes',
            options: Options(
              headers: {'Authorization': 'Bearer $accessToken'},
            ),
            // data: {}
        );
      } else {
        await dio.post(
            'http://${dotenv.env['LOCAL_API_URL']}/news/${news_id}/likes',
            options: Options(
              headers: {'Authorization': 'Bearer $accessToken'},
            ),
            // data: {}
        );
      }
    });
  }

}