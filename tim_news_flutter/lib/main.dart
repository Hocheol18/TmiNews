import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/news/news_create_completion.dart';
import 'package:tim_news_flutter/screens/loginPage.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tim_news_flutter/screens/main_container.dart';
import 'news/news_create_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_KEY'] ?? '';
  // 환경변수 로그인
  KakaoSdk.init(nativeAppKey: dotenv.env['NATIVE_APP_KEY'] ?? '');
  KakaoSdk.init(nativeAppKey: nativeAppKey, javaScriptAppKey: javaScriptAppKey);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMI_NEWS',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainContainer(),
        '/create': (context) => NewsCreatePage(),
        '/test': (context) => NewsCreateCompletion(),
      },
    );
  }
}
