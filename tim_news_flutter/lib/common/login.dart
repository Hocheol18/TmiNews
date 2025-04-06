import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tim_news_flutter/api/api_login/login/authRepository.dart';
import '../screens/mainPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  print("dasdf");
  KakaoSdk.init(nativeAppKey:dotenv.env['NATIVE_APP_KEY']);

  try {
    final hashkey = await KakaoSdk.origin;
    print(hashkey);
  } catch (e) {
    print(e);
  }

}

Future<bool> loginLogic(BuildContext context, WidgetRef ref) async {
  final String redirectUri = "kakao${dotenv.env['NATIVE_APP_KEY']}://oauth";
  final String serverUri = 'http://${dotenv.env['LOCAL_API_URL']}/auth/kakao';


  // apiService 가져오기
  final apiService = ref.read(authRepositoryProvider);

  try {
    // 토큰이 이미 있는지 확인
    if (await AuthApi.instance.hasToken()) {
      try {
        // 토큰 유효성 확인
        await UserApi.instance.accessTokenInfo();

        // 토큰 유효하면 인가 코드만 요청
        final String authCode = await AuthCodeClient.instance.authorize(
          redirectUri: redirectUri,
        );

        await apiService.apiPost(serverUri, authCode);
        return true;
      } catch (error) {
        print("1");
        // 토큰이 유효하지 않거나 만료된 경우
        // 아래 로그인 로직으로 계속 진행
      }
    }

    // 토큰이 없거나 유효하지 않은 경우 로그인 시도
    try {
      print("2");
      // 카카오톡 앱이 설치되어 있는지 확인
      if (await isKakaoTalkInstalled()) {
        try {
          // 카카오톡으로 로그인 시도
          await UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          // 사용자가 취소했거나 카카오톡 로그인 실패
          if (error is PlatformException && error.code == 'CANCELED') {
            print("3");
            showCupertinoModalPopup<void>(
              context: context,
              builder:
                  (BuildContext context) => CupertinoAlertDialog(
                    content: const Text('로그인 실패, 다시 시도해주세요'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text('확인했습니다'),
                      ),
                    ],
                  ),
            );
            return false;
          }
          // 카카오톡 로그인 실패 → 카카오계정으로 전환
          await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        // 카카오톡 설치되지 않은 경우 바로 카카오계정으로 로그인
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 로그인 성공 후 인가 코드 요청
      final String authCode = await AuthCodeClient.instance.authorize(
        redirectUri: redirectUri,
      );

      await apiService.apiPost(serverUri, authCode);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

class KakaoLogin extends ConsumerWidget {
  const KakaoLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // GestureDetector 사용
    return GestureDetector(
      onTap: () async {
        final success = await loginLogic(context, ref);
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
