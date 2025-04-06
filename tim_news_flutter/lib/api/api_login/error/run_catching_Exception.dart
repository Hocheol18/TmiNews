import 'package:dio/dio.dart';
import 'package:tim_news_flutter/api/api_login/error/result.dart';

import 'custom_exception.dart';

Future<Result<T, CustomExceptions>> runCatchingExceptions<T>(
    Future<T> Function() block) async {
  try {
    final result = await block();
    return Result.success(result);
  } catch (e) {
    if (e is DioException) {
      return Result.failure(CustomExceptions.fromDioException(e));
    }
    return Result.failure(CustomExceptions.unknownError(e.toString()));
  }
}