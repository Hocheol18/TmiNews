import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> apiPost(String site, String code) async {
  final response = await http.post(
    Uri.parse(site),
    headers: {
      'Content-Type': 'application/json',
    },
    body : jsonEncode({
      "code" : code
    })
  );

  try {
    final jsonData = jsonDecode(response.body);
    print(jsonData);
    // 계속 처리
  } catch (e) {
    return;
  }
}