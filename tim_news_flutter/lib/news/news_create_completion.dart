import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsCreateDetailPage extends StatelessWidget {
  const NewsCreateDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.content,
    required this.newsTime,
  });

  final String title;
  final String category;
  final String content;
  final String newsTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(category)),
    );
  }
}

class NewsCreateCompletion extends StatelessWidget {
  const NewsCreateCompletion({super.key, this.res});

  final Response? res;

  // getter 쓰는 이유는 Dart언어의 특성
  // 인스턴스 변수 초기화는 생성자가 실행되기 전에 이루어짐.
  // getter는 실제로 클래스 메서드와 유사하게 작동함
  // getter 호출될 때 (런타임) 평가되지, 클래스 인스턴스가 생성될 때 (컴파일) 평가되지 않음
  // 따라서 title getter가 호출될 때는 res 변수가 완전히 초기화된 상태
  String get title => res?.data['title'] ?? '제목 없음';

  String get category => res?.data['category'] ?? '카테고리 없음';

  String get content => res?.data['content'] ?? '컨텐츠 없음';

  String get newsTime => res?.data['newsTime'] ?? '시간 없음';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('뉴스 생성 완료!')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: NewsCreateDetailPage(
              title: title,
              category: category,
              content: content,
              newsTime: newsTime,
            ),
          ),
        ],
      ),
    );
  }
}
