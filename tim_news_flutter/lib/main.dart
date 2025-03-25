import 'package:flutter/material.dart';
import 'package:tim_news_flutter/screens/loginPage.dart';
import 'package:tim_news_flutter/screens/mainPage.dart';

import 'news/newsCreatePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내 앱',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main' : (context) => MainPage(),
        '/create' : (context) => NewsCreatePage(),
      },
    );
  }
}