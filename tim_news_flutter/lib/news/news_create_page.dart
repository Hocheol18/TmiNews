import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tim_news_flutter/theme/colors.dart';
import '../theme/news_create_page_styles.dart';
import 'calendar/calendar.dart';
import 'image/image_picker.dart';
import 'providers/news_provider.dart';

class NewsCreatePage extends ConsumerWidget {
  const NewsCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              '/main',
            );
          },
          child: Icon(CupertinoIcons.back),
        ),
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

//TODO :: 유효성 검사 해야함.

class News_create extends ConsumerStatefulWidget {
  const News_create({super.key});

  @override
  ConsumerState<News_create> createState() => _News_createState();
}

class _News_createState extends ConsumerState<News_create> {
  final menuItems = ['재테크', 'IT', '건강', '사회', '연예', '스포츠'];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int textLength = 10;
  String selectedCategory = '재테크';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsData = ref.read(newsProvider);
      _titleController.text = newsData.title;
      _contentController.text = newsData.content;
      selectedCategory = newsData.category;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? checkErrorText() {
    if (_contentController.text.isEmpty) return null;
    return _contentController.text.length >= textLength
        ? null
        : "10글자 이상 입력해주세요.";
  }

  @override
  Widget build(BuildContext context) {
    final newsNotifier = ref.read(newsProvider.notifier);
    final newsData = ref.watch(newsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('기사 분류', style: titleTextStyle),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        menuItems
                            .map(
                              (item) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = item;
                                  });
                                  newsNotifier.setCategory(item);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        selectedCategory == item
                                            ? yellowColor
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(item, style: menuTextStyle),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                SizedBox(height: 20),
                Text('기사 제목', style: titleTextStyle),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: TextFormField(
                    controller: _titleController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
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
                    onChanged: (value) {
                      newsNotifier.setTitle(value);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text('기사 날짜', style: titleTextStyle),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TableBasicsExample(),
                      ),
                    ).then((value) {
                      // 날짜가 선택되어 반환되었을 때 처리
                      if (value != null) {
                        newsNotifier.setDate(value);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(newsData.date),
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text('기사 내용', style: titleTextStyle),
                Scrollbar(
                  controller: _scrollController,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: TextFormField(
                      scrollController: _scrollController,
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        errorText: checkErrorText(),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                        errorMaxLines: 1,
                      ),
                      onChanged: (value) {
                        newsNotifier.setContent(value);
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ImageAdd()),
                  );
                },
                child: Text(
                  '다음으로',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
