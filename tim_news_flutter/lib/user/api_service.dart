// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:your_app/user/auth_service.dart';
//
// final apiServiceProvider = Provider<ApiService>((ref) {
//   // final dio = ref.watch(dioProvider);
//   // return ApiService(dio, 'https://your-api-url.com/api'); // 실제 API URL로 변경 필요
// });
//
// class ApiService {
//   final Dio dio;
//   final String baseUrl;
//
//   ApiService(this.dio, this.baseUrl);
//
//   // 코드 API 호출 예시
//   Future<Map<String, dynamic>?> processCode(String code) async {
//     try {
//       final response = await dio.post(
//           '$baseUrl/process-code',
//           data: {'code': code}
//       );
//
//       return response.data;
//     } catch (e) {
//       print('[ERR] API 요청 실패: $e');
//       return null;
//     }
//   }
//
//   // 데이터 가져오기 예시
//   Future<List<dynamic>?> fetchData() async {
//     try {
//       final response = await dio.get('$baseUrl/data');
//       return response.data;
//     } catch (e) {
//       print('[ERR] 데이터 가져오기 실패: $e');
//       return null;
//     }
//   }
// }