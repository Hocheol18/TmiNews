import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> logOut() async {
  try {
    await UserApi.instance.logout();
    print('로그아웃 성공, SDK에서 토큰 폐기');
  } catch (error) {
    print('로그아웃 실패, SDK에서 토큰 폐기 $error');
  }
}
