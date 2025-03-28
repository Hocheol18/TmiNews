import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../user/secure_storage.dart';
import '../dio.dart';
import '../error/custom_exception.dart';
import '../error/result.dart';
import '../error/run_catching_Exception.dart';

part 'authRepository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(dio: dio, storage: storage);
}

class AuthRepository {
  AuthRepository({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;

  Future<Result<void, CustomExceptions>> apiPost(
    String site,
    String code,
  ) async {
    return runCatchingExceptions(() async {
      // 1. API 요청 수행
      final response = await kakaoRequest(site, code);

      // 2. 응답에서 토큰 저장
      await tokenSave(response);

      // 3. 카카오 사용자 정보 가져오기 및 저장
      await kakaoMatch();
    });
  }

  Future<Response> kakaoRequest(String site, String code) async {
    return await dio.post(
      site,
      data: {"code": code},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<void> tokenSave(Response response) async {
    final jsonData = response.data;
    await Future.wait([
      storage.saveAccessToken(jsonData['accessToken']),
      storage.saveRefreshToken(jsonData['refreshToken']),
    ]);
  }

  Future<void> kakaoMatch() async {
    final user = await UserApi.instance.me();

    // 필요한 정보가 모두 있는지 확인
    final kakaoAccount = user.kakaoAccount;
    final profile = kakaoAccount?.profile;
    final nickname = profile?.nickname;
    final email = kakaoAccount?.email;
    if (kakaoAccount == null &&
        profile == null &&
        (nickname == null || email == null)) {
      print('카카오 계정 정보가 없습니다.');
      return;
    }

    // 사용자 정보 저장
    await storage.saveUserInfo(user.id.toString(), nickname!, email!);

    print(
      '사용자 정보 저장 성공\n'
      '회원번호: ${user.id}\n'
      '닉네임: $nickname\n'
      '이메일: $email',
    );
  }
}
