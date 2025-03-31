import 'package:flutter/material.dart';
import 'package:tim_news_flutter/theme/colors.dart';

import '../theme/news_create_page_styles.dart';

class NewsCreatePage extends StatelessWidget {
  const NewsCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나만의 뉴스 만들기',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: yellowColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: News_create(),
      ),
    );
  }
}

class News_create extends StatelessWidget {
  News_create({super.key});

  final menuItems = ['재테크', 'IT', '건강', '사회', '연애', '스포츠'];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('기사 분류 *', style: titleTextStyle),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                menuItems
                    .map((item) => Text(item, style: menuTextStyle))
                    .toList(),
          ),
        ),
        SizedBox(height: 25),
        Text('기사 내용 *', style: titleTextStyle),
        Scrollbar(
          controller: _scrollController, // 스크롤 컨트롤러 연결
          child: Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: TextFormField(
              scrollController: _scrollController,
              // TextFormField에도 동일한 스크롤 컨트롤러 연결
              maxLines: null,
              // 여러 줄 입력 가능
              expands: true,
              // 부모 높이에 맞게 확장
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
