import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tim_news_flutter/api/login/loginPost.dart';
import '../screens/mainPage.dart';

Future<bool> loginLogic() async {
  final String redirectUri = "kakao${dotenv.env['NATIVE_APP_KEY']}://oauth";

  // 기존 토큰 존재 여부 확인
  if (await AuthApi.instance.hasToken()) {
    try {
      final AccessTokenInfo tokenInfo =
          await UserApi.instance.accessTokenInfo();
      final String authCode = await AuthCodeClient.instance.authorize(
        redirectUri: redirectUri,
      );
      //TODO :: 로그인 리다이렉트
      print(authCode);
      apiPost('http://192.168.0.12:8080/auth/kakao', authCode);
      return true;
    } catch (error) {
      // ✅ 토큰은 있지만 만료 또는 유효하지 않은 경우
      if (error is KakaoException && error.isInvalidTokenError()) {
        print('⚠️ 토큰 만료: $error');
        return false;
      } else {
        print('❌ 토큰 조회 실패: $error');
        return false;
      }
    }
  }

  // 로그인 시도 (토큰 없거나 실패했을 때)
  try {
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED')
          return false;
        // 카카오톡 로그인 실패 → 카카오계정 로그인 시도
        token = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    // 로그인 성공 후 authCode 요청
    final String authCode = await AuthCodeClient.instance.authorize(
      redirectUri: redirectUri,
    );
    apiPost('http://192.168.0.12:8080/auth/kakao', authCode);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

class KakaoLogin extends StatelessWidget {
  const KakaoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    // GestureDetector 사용
    return GestureDetector(
      onTap: () async {
        final success = await loginLogic();
        if (context.mounted && success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // 이런식으로 설정
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(7), // 둥근 모서리
        ),
        child: Image.asset('assets/images/kakao_login.png'),
      ),
    );
  }
}
