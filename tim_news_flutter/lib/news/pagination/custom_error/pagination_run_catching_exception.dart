import 'package:dio/dio.dart';
import 'package:tim_news_flutter/news/pagination/custom_error/pagination_custom_error.dart';
import 'package:tim_news_flutter/news/pagination/result/pagination_result.dart';


Future<Result<T>> runCatchingExceptions<T>(Future<T> Function() block) async {
  try {
    final result = await block();
    return Result.success(result); // ✅ freeezed Result<T>
  } catch (e) {
    if (e is DioException) {
      // 예외 매핑은 네가 커스텀한 CustomExceptions 기반으로
      return Result.failure(CustomExceptions.networkError("네트워크 오류"));
    }
    return Result.failure(CustomExceptions.unknownError("알 수 없는 오류"));
  }
}