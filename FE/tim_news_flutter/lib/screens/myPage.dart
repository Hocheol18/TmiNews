import 'package:flutter/material.dart';
import '../common/bottomNavigator.dart';
import '../mypage/myPage.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MypageMain(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
