import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_news_flutter/api/api_login/login/authRepository.dart';
import 'package:tim_news_flutter/common/topNavigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../user/secure_storage.dart';
import '../api/api_login/provider/provider.dart';
import 'package:tim_news_flutter/common/articleBlock.dart';

class NewsMainPage extends ConsumerStatefulWidget {
  const NewsMainPage({super.key});

  @override
  ConsumerState<NewsMainPage> createState() => _NewsMainPageState();
}

class _NewsMainPageState extends ConsumerState<NewsMainPage> {
  final List<String> _tabTitles = ['재테크', 'IT', '건강', '사회', '연애', '스포츠'];
  int _tabIndex = 0;

  void _handleTabChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Container(child: ElevatedButton(onPressed: () async {
            final secureStorage = ref.read(secureStorageProvider);

            // 토큰 불러오기
            final accessToken = await secureStorage.readAccessToken();
            final refreshToken = await secureStorage.readRefreshToken();
            final userModel = await secureStorage.readUserInfo();
            print(userModel?.nickname);

            print('Access Token: $accessToken');
            print('Refresh Token: $refreshToken');
          }, child: Text('눌러')),),
          SizedBox(
            width: 100,
            height: 100,
            child: ArticleBlock(content: '임시 뉴스 바로가기', news_id: 1)
          )
        ],
      ),
    );
  }
}
