// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      index: (json['index'] as num).toInt(),
      customCursor: json['customCursor'] as String?,
      category: json['category'] as String,
      limit: (json['limit'] as num?)?.toInt() ?? 12,
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'index': instance.index,
      'customCursor': instance.customCursor,
      'category': instance.category,
      'limit': instance.limit,
    };
