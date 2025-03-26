import 'package:flutter/material.dart';
import 'package:tim_news_flutter/common/topNavigator.dart';

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
    );
  }
}
