import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_custom_error.freezed.dart';

@freezed
sealed class CustomExceptions with _$CustomExceptions {
  const factory CustomExceptions.notFound([String? message]) = NotFound;
  const factory CustomExceptions.notingStore([String? message]) = NotingStore;
  const factory CustomExceptions.unauthorized([String? message]) = Unauthorized;
  const factory CustomExceptions.unknownError([String? message]) = UnknownError;
  const factory CustomExceptions.serverError([String? message]) = ServerError;
  const factory CustomExceptions.networkError([String? message]) = NetworkError;

  factory CustomExceptions.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode == 401 || statusCode == 403) {
          return CustomExceptions.unauthorized("인증 오류");
        } else if (statusCode == 404) {
          return CustomExceptions.notFound("페이지를 찾을 수 없습니다");
        } else if (statusCode >= 500) {
          return CustomExceptions.serverError("서버 오류 발생");
        }
        return CustomExceptions.unknownError("알 수 없는 오류: ${e.message}");
      default:
        return CustomExceptions.networkError("네트워크 오류: ${e.message}");
    }
  }

}