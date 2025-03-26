import 'package:flutter/material.dart';
import 'package:tim_news_flutter/screens/loginPage.dart';
import 'package:tim_news_flutter/screens/mainPage.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'news/newsCreatePage.dart';

Future<void> main() async {
  // 환경변수 로그인
  await dotenv.load(fileName: ".env");
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_KEY'] ?? '';

  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
    javaScriptAppKey: javaScriptAppKey,
  );

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