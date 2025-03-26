import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_news_flutter/common/topNavigator.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class NewsMainPage extends StatefulWidget {
  const NewsMainPage({super.key});

  @override
  State<NewsMainPage> createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  final List<String> _tabTitles = ['재테크', 'IT', '건강', '사회', '연애', '스포츠'];
  int _tabIndex = 0;

  void _handleTabChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  logoutFunction() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 폐기 $error');
    }
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
                onPressed: () {
                  logoutFunction();
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
    );
  }
}
