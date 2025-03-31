import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/provider/provider.dart';

import '../user/secure_storage.dart';
import 'model/exception_model.dart';
import 'model/user_model.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
      CustomInterceptor(storage: storage, ref: ref)
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final SecureStorage storage;
  late final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  get ip => dotenv.env['LOCAL_API_URL'];

  // 1) 요청을 보낼때
  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');
      final token = await storage.readAccessToken();
      print('[BEFORE_REQ_HEADER] ${options.headers}');
      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': token,
      });
      print('[REQ_HEADER] ${options.headers}');
      print('[REQ_DATA] ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions
            .uri}');
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} ');

    final errorModel = ExceptionModel.fromJson(err.response!.data);
    final UserModel? userInfo = await storage.readUserInfo();

    if (userInfo == null) {
      storage.logout(); // 토큰 비우기
      return handler.reject(err);
    }

    final unAuthorized = errorModel.errorCode == '0007';
    final isPathRefresh =
        err.requestOptions.path == '/auth/refresh'; // false: 에세스 토큰 재발급 필요
    final isPathLogin =
        err.requestOptions.path != '/auth/kakao'; // false: 리프레시토큰 재발급 필요

    if (!unAuthorized || (!isPathRefresh && !isPathLogin)) {
      return handler.reject(err);
    }
    // 에세스 토큰 발급 요청이 아닐 때 => 에세스토큰 만료 확인
    // 리프레시 토큰마저 만료일 때 => 리프레시 토큰 만료 확인

    final dio = Dio();
    final refreshToken = await storage.readRefreshToken();
    try {
      final resp = await dio.post(
        'http://$ip/auth/refresh',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      final String accessToken = resp.data['body']['accessToken'];
      final options = err.requestOptions;
      // 토큰 변경하기
      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });
      await storage.saveAccessToken(accessToken);

      // 요청 재전송
      final response = await dio.fetch(options);

      return handler.resolve(response);
    } on DioException catch (e) {
      final errorModel = ExceptionModel.fromJson(e.response!.data);
      print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
      print('[ERR_NUMBER] ${errorModel.errorCode}');
      final unAuthorized = errorModel.errorCode == '0007';
      if (!unAuthorized) {
        return handler.reject(e);
      }
      // 리프레시 토큰 에러
      try {
        final resp = await dio.post(
            'http://$ip/auth/refresh',
            options: Options(
              headers: {
                'authorization': 'Bearer $refreshToken',
              },

            ));
            final String accessToken = resp.data['body']['accessToken'];
            await Future.wait([
              storage.saveAccessToken(accessToken),
            ]);
            final options = err.requestOptions;
            options.headers.addAll({
        'authorization': 'Bearer $accessToken',
        });
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } catch (e) {
        // 로그인 불가능 -> 로그인 화면으로 라우팅
        print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
        print('[ERR_NUMBER] ${errorModel.errorType}');

        await ref.read(authControllerProvider.notifier).logOut();
        return handler.reject(err);
      }
    }
  }
}

