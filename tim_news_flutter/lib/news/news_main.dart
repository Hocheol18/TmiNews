import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_news_flutter/api/api_news/news_get/news_all.dart';
import 'package:tim_news_flutter/common/topNavigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';

import '../common/loading_page.dart';

final dataHashProvider = StateProvider<Map<String, String>>((ref) => {});
final newsCacheData = StateProvider<Map<String, dynamic>>((ref) => {});

String computeHash(dynamic data) {
  final jsonString = jsonEncode(data);
  final bytes = utf8.encode(jsonString);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

final newsFetchProvider = FutureProvider.family((ref, String category) async {
  final repository = ref.read(newsRepositoryProvider);
  final result = await repository.newsFetch(category, 1, 1);

  final newHash = computeHash(result.data['data']);
  final dataHash = ref.read(dataHashProvider);

  if (!dataHash.containsKey(category) || dataHash[category] != newHash) {
    ref.read(dataHashProvider.notifier).update((state) {
      final newState = Map<String, String>.from(state);
      newState[category] = newHash;
      return newState;
    });

    ref.read(newsCacheData.notifier).update((state) {
      final newState = Map<String, dynamic>.from(state);
      newState[category] = result;
      return newState;
    });
  }

  return result;

});

class NewsContent extends StatelessWidget {
  const NewsContent({super.key, required this.newsList});

  final List<dynamic> newsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child:
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
        ),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final item = newsList[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  .withValues(alpha: 0.3),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    item['title'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

class NewsMainPage extends ConsumerStatefulWidget {
  const NewsMainPage({super.key});

  @override
  ConsumerState<NewsMainPage> createState() => _NewsMainPageState();
}

class _NewsMainPageState extends ConsumerState<NewsMainPage> {
  final List<String> _tabTitles = ['재테크', 'IT', '건강', '사회', '연예', '스포츠'];
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(newsFetchProvider(_tabTitles[_tabIndex]));
    });
  }

  void _handleTabChanged(int index) {
    setState(() {
      _tabIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    final newsValue = ref.watch(newsFetchProvider(_tabTitles[_tabIndex]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('TMI'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: TopNavigator(
            tabTitles: _tabTitles,
            onTabChanged: _handleTabChanged,
            tabIndex: _tabIndex,
          ),
        ),
      ),
      body:
      newsValue.when(
        data: (newsData) {
          final newsList = newsData.data['data'] ?? ['노데이터'];
          return NewsContent(newsList: newsList);
        },
        loading: () => const LoadingPage(title: '뉴스를 받아오는 중입니다...'),
        error: (error, stack) => Center(child: Text("오류 발생, $error")),
      ),
    );
  }
}
