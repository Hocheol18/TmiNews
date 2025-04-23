import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/dio.dart';
import '../../user/secure_storage.dart';
import '../api_login/error/result.dart';
import '../api_login/error/custom_exception.dart';
import '../api_login/error/run_catching_Exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tim_news_flutter/mypage/mypage_class.dart';

final mypageApiServiceProvider = Provider<MypageApiService>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return MypageApiService(dio: dio, storage: storage);
});

class MypageApiService {
  MypageApiService({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;


  // 마이페이지 조회
  Future<Result<Map<String, dynamic>, CustomExceptions>> getUserProfile(sortType) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/mypage?sortBy=${sortType}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response.data;
    });
  }


  // 전체 알림 리스트 조회
  Future<Result<List<Alarm>, CustomExceptions>> getAlarmList() async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/notifications/unread',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      // 빈 배열이 오는 경우를 처리
      if (response.data is List) {
        List<dynamic> dataList = response.data as List;
        return dataList.map((data) =>
            Alarm.fromJson(data as Map<String, dynamic>)).toList();
      }

      // 예외 상황: 배열이 아닌 경우 빈 배열 반환
      return <Alarm>[];
    });
  }

  // 친구 목록 조회
  Future<Result<List<FriendInfo>, CustomExceptions>> getFriendList() async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/friends/list',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      // 빈 배열이 오는 경우를 처리
      if (response.data is List) {
        List<dynamic> dataList = response.data as List;
        return dataList.map((data) =>
            FriendInfo.fromJson(data as Map<String, dynamic>)).toList();
      }

      // 예외 상황: 배열이 아닌 경우 빈 배열 반환
      return <FriendInfo>[];
    });
  }


  // 내친구 검색
  Future<Result<List<FriendInfo>, CustomExceptions>> searchMyFriend(String keyword) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/friends/search?keyword=${keyword}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      // 빈 배열이 오는 경우를 처리
      if (response.data is List) {
        List<dynamic> dataList = response.data as List;
        return dataList.map((data) =>
            FriendInfo.fromJson(data as Map<String, dynamic>)).toList();
      }

      // 예외 상황: 배열이 아닌 경우 빈 배열 반환
      return <FriendInfo>[];
    });
  }

  // 아이디로 친구 정보 검색
  Future<Result<List<FriendInfo>, CustomExceptions>> searchNewFriend(String searchKeyword) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/user/search?keyword=${searchKeyword}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      // 빈 배열이 오는 경우를 처리
      if (response.data is List) {
        List<dynamic> dataList = response.data as List;
        return dataList.map((data) =>
            FriendInfo.fromJson(data as Map<String, dynamic>)).toList();
      }

      // 예외 상황: 배열이 아닌 경우 빈 배열 반환
      return <FriendInfo>[];
    });
  }

  // 친구 추가
  Future<Result<void, CustomExceptions>> addNewFriend(int userId) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      await dio.post(
        'http://${dotenv
            .env['LOCAL_API_URL']}/friends/request?toUserId=${userId}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print('친구 신청보냄');
    });
  }

  // 친구 마이페이지 조회
  Future<Result<Map<String, dynamic>, CustomExceptions>> getFriendProfile(friendId, sortType) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();

      final response = await dio.get(
        'http://${dotenv.env['LOCAL_API_URL']}/friends/mypage?friendId=${friendId}&sortBy=${sortType}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response.data;
    });
  }

  // 친구 수락
  Future<Result<void, CustomExceptions>> acceptFriend(userId) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      await dio.post(
        'http://${dotenv.env['LOCAL_API_URL']}/friends/accept?requestId=${userId}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    });
  }

  // 친구 거절
  Future<Result<void, CustomExceptions>> rejectFriend(userId) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      await dio.post(
        'http://${dotenv.env['LOCAL_API_URL']}/friends/reject?requestId=${userId}',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    });
  }


  // 알람 읽음 처리
  Future<Result<void, CustomExceptions>> readAlarm(notificationId) async {
    return runCatchingExceptions(() async {
      final accessToken = await storage.readAccessToken();
      await dio.post(
        'http://${dotenv.env['LOCAL_API_URL']}/notifications/${notificationId}/read',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    });
  }
}