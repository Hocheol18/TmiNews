// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsPaginationModel _$NewsPaginationModelFromJson(Map<String, dynamic> json) =>
    NewsPaginationModel(
      id: (json['newsId'] as num).toInt(),
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$NewsPaginationModelToJson(
  NewsPaginationModel instance,
) => <String, dynamic>{
  'newsId': instance.id,
  'category': instance.category,
  'title': instance.title,
  'content': instance.content,
  'date': instance.date.toIso8601String(),
  'imagePath': instance.imagePath,
};
