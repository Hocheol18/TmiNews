import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<void> kakaoLogout() async {
    final String? refreshToken = await storage.readRefreshToken();
    final String? accessToken = await storage.readAccessToken();

    await dio.post(
      'http://${dotenv.env['LOCAL_API_URL']}/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),

    );
  }

  Future<void> kakaoMatch() async {
    final user = await UserApi.instance.me();
    final kakaoAccount = user.kakaoAccount;
    final profile = kakaoAccount?.profile;
    if (profile == null) {
      return;
    }

    final nickname = profile.nickname;
    final profile_image_url = profile.profileImageUrl;

    // 사용자 정보 저장
    await storage.saveUserInfo(nickname!, profile_image_url!);
  }
}
