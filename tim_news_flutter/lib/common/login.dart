import 'package:flutter/material.dart';

import '../screens/mainPage.dart';

class KakaoLogin extends StatelessWidget {
  const KakaoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          '카카오로 로그인하기',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
