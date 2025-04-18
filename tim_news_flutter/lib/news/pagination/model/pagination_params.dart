import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()

class PaginationParams {
  final int index;
  final String? customCursor;
  final String category;
  final int limit;

  const PaginationParams({
    required this.index,
    this.customCursor,
    required this.category,
    this.limit = 12,
  });

  PaginationParams copyWith({
    required int index,
    String? customCursor,
    required String category,
    required int limit,
  }) {
    return PaginationParams(
      index: index,
      customCursor: customCursor ?? this.customCursor,
      category: category,
      limit : limit,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}