import 'package:json_annotation/json_annotation.dart';

part 'pagination_state.g.dart';

abstract class PaginationBase {}

class PaginationError extends PaginationBase {
  final ErrorMapper mapper;

  PaginationError({required this.mapper});
}

class PaginationLoading extends PaginationBase {}

class PaginationNothing extends PaginationBase {
  final ErrorMapper mapper;

  PaginationNothing({required this.mapper});
}

//Pagination(Data)
@JsonSerializable(genericArgumentFactories: true)
class Pagination<T> extends PaginationBase {
  final List<T> data;

  Pagination({required this.data});

  Pagination copyWith({List<T>? data}) {
    return Pagination<T>(data: data ?? this.data);
  }

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginationFromJson(json, fromJsonT);
}

// 새로고침 할때
class PaginationRefetching<T> extends Pagination<T> {
  PaginationRefetching({required super.data});
}

// 리스트의 맨 아래로 내려서 추가 데이터를 요청중
class PaginationFetchingMore<T> extends Pagination<T> {
  PaginationFetchingMore({required super.data});
}

class ErrorMapper {}
