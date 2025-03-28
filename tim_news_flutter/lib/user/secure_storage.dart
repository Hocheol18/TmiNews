// user.dart 파일
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/api/model/user_model.dart';

// riverpod_generator를 위한 코드 생성
part 'secure_storage.g.dart';


const String REFRESH_TOKEN = 'REFRESH_TOKEN';
const String ACCESS_TOKEN = 'ACCESS_TOKEN';

@Riverpod(keepAlive: true)
// 이 코드 자체가 프로바이더 자체 생성.
FlutterSecureStorage storage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  final FlutterSecureStorage storage = ref.read(storageProvider);
  return SecureStorage(storage: storage);
}

class SecureStorage {
  final FlutterSecureStorage storage;

  SecureStorage({
    required this.storage,
  });

  // 리프레시 토큰 저장
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await storage.write(key: REFRESH_TOKEN, value: refreshToken);
    } catch (e) {
      print("[ERR] RefreshToken 저장 실패: $e");
    }
  }

  // 리프레시 토큰 불러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: REFRESH_TOKEN);
      return refreshToken;
    } catch (e) {
      print("[ERR] RefreshToken 불러오기 실패: $e");
      return null;
    }
  }

  // 액세스 토큰 저장
  Future<void> saveAccessToken(String accessToken) async {
    try {
      await storage.write(key: ACCESS_TOKEN, value: accessToken);
    } catch (e) {
      print("[ERR] AccessToken 저장 실패: $e");
    }
  }

  // 액세스 토큰 불러오기
  Future<String?> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);
      return accessToken;
    } catch (e) {
      print("[ERR] AccessToken 불러오기 실패: $e");
      return null;
    }
  }

  Future<void> saveUserInfo(String id, String nickname, String email) async {
    try {
      final userInfoJson = jsonEncode({
        'id': id,
        'nickname': nickname,
        'email': email
      });

      await storage.write(key: "userinfo", value: userInfoJson);
    } catch (e) {
      print("userInfo 저장 실패 $e");
    }
  }

  Future<UserModel?> readUserInfo() async {
    try {
      final userInfo = await storage.read(key: 'userinfo');
      if (userInfo == null) return null;

      final userInfoMap = jsonDecode(userInfo) as Map<String, dynamic>;
      return UserModel.fromJson(userInfoMap);
    } catch (e) {
      print("[ERR] 유저 불러오기 실패: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      await storage.delete(key:ACCESS_TOKEN);
      await storage.delete(key:REFRESH_TOKEN);
      await storage.delete(key: 'userinfo');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 폐기 $error');
    }
  }
}