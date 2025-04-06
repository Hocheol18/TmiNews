import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/screens/loginPage.dart';
import 'package:tim_news_flutter/screens/mainPage.dart';
import 'package:tim_news_flutter/screens/myPage.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tim_news_flutter/test.dart';
import 'news/news_create_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_KEY'] ?? '';
  // 환경변수 로그인
  KakaoSdk.init(nativeAppKey: dotenv.env['NATIVE_APP_KEY'] ?? '');
  final hashkey = await KakaoSdk.origin;
  print(hashkey);
  KakaoSdk.init(nativeAppKey: nativeAppKey, javaScriptAppKey: javaScriptAppKey);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '내 앱',
      initialRoute: '/create',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
        '/create': (context) => NewsCreatePage(),
        '/mypage': (context) => MyPage(),
        '/test': (context) => Test(),
      },
    );
  }
}
