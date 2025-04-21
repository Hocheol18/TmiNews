import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tim_news_flutter/news/pagination/custom_error/pagination_custom_error.dart';

part 'pagination_result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(CustomExceptions error) = Failure<T>;
}