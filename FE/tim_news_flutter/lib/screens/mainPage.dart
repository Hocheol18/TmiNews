import 'package:flutter/material.dart';
import '../common/bottomNavigator.dart';
import '../news/news_main.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NewsMainPage(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
