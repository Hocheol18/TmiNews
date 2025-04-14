import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/theme/colors.dart';

import '../screens/mainPage.dart';
import '../theme/news_create_completion_page.dart';
import 'image/image_data_submit.dart';
import 'news_create_page.dart';

class NewsCreateDetailPage extends StatelessWidget {
  NewsCreateDetailPage({
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

  final ScrollController _scrollController = ScrollController();

  void dispose() {
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixedNewsTime = newsTime.substring(2, 10);
    return Column(
      children: [
        Text(
          title,
          style: titleTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('발행 날짜 : $fixedNewsTime', style: secondTextStyle),
            Text('카테고리 : $category', style: secondTextStyle),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Text(content, style: bodyTextStyle),
            ),
          ),
        ),
      ],
    );
  }
}

class NewsCreateCompletion extends ConsumerStatefulWidget {
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
  ConsumerState<NewsCreateCompletion> createState() =>
      _NewsCreateCompletionState();
}

class _NewsCreateCompletionState extends ConsumerState<NewsCreateCompletion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('뉴스 생성 완료!', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: NewsCreateDetailPage(
              title: widget.title,
              category: widget.category,
              content: widget.content,
              newsTime: widget.newsTime,
            ),
          ),
          GestureDetector(
            onTap: () async {
              //TODO :: FIREBASE로 공유만들기
              Response res = await newsCreatePostSubmit(
                ref,
                widget.category,
                widget.content,
                widget.title,
                widget.newsTime,
              );
              if (res.statusCode == 201) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MainPage()),
                  (route) => false,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: yellowColor,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(child: Text('발행하기', style: buttonTextStyle)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => NewsCreatePage()),
                (route) => false,
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 15, 50, 0),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(child: Text('다시 생성하기', style: buttonTextStyle)),
            ),
          ),
        ],
      ),
    );
  }
}
