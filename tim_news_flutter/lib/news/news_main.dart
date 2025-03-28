import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/api/login/authRepository.dart';
import 'package:tim_news_flutter/common/topNavigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../user/secure_storage.dart';
import '../api/provider/provider.dart';

@riverpod
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

  kakaoLogout() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            content: const Text('로그아웃하시겠습니까?'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('아니오'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  final secureStorage = ref.read(secureStorageProvider);
                  await secureStorage.logout();
                  await ref.read(authControllerProvider.notifier).logOut();
                  await ref.read(authRepositoryProvider).kakaoLogout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('예'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMI'),
        actions: [
          ElevatedButton(
            onPressed: () {
              kakaoLogout();
            },
            child: Icon(Icons.logout),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: TopNavigator(
            tabTitles: _tabTitles,
            onTabChanged: _handleTabChanged,
            tabIndex: _tabIndex,
          ),
        ),
      ),
      body: Container(child: ElevatedButton(onPressed: () async {
        final secureStorage = ref.read(secureStorageProvider);

        // 토큰 불러오기
        final accessToken = await secureStorage.readAccessToken();
        final refreshToken = await secureStorage.readRefreshToken();
        final userModel = await secureStorage.readUserInfo();
        print(userModel?.nickname);


        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');
      }, child: Text('눌러')),),
    );
  }
}
