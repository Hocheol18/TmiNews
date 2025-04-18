import 'package:json_annotation/json_annotation.dart';

import '../pagination/class/IModelWithIdClass.dart';

part 'news_pagination_model.g.dart';

@JsonSerializable()
class NewsPaginationModel implements IModelWithId {
  @override
  @JsonKey(name: 'newsId') // 기존 명명 규칙에 맞춤
  final int id; // IModelWithId 구현을 위한 id 필드 추가

  final String category;
  final String title;
  final String content;
  final DateTime date;
  final String? imagePath;

  NewsPaginationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
  });

  // 기본값을 가진 생성자
  factory NewsPaginationModel.empty() => NewsPaginationModel(
    id: 0,
    category: '재테크',
    title: '',
    content: '',
    date: DateTime.now(),
  );

  NewsPaginationModel copyWith({
    int? id,
    String? category,
    String? title,
    String? content,
    DateTime? date,
    String? imagePath,
  }) {
    return NewsPaginationModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory NewsPaginationModel.fromJson(Map<String, dynamic> json) =>
      _$NewsPaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsPaginationModelToJson(this);
}