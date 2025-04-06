import 'package:dio/dio.dart';

class CustomExceptions {
  final String message;
  final int? statusCode;

  CustomExceptions({
    required this.message,
    this.statusCode,
  });

  factory CustomExceptions.fromDioException(DioException e) {
    return CustomExceptions(
      message: e.message ?? 'Unknown error occurred',
      statusCode: e.response?.statusCode,
    );
  }

  factory CustomExceptions.unknownError(String message) {
    return CustomExceptions(
      message: message,
    );
  }
}