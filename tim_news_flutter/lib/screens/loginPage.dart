import 'package:flutter/material.dart';

import '../common/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

textFunction(String txt, double txtSize) {
  return RotateAnimatedText(
    txt,
    textAlign: TextAlign.left,
    alignment: Alignment.centerLeft,
    textStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: txtSize),
    duration: const Duration(milliseconds: 2000),
  );
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나만의',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                width: 150,
                child: AnimatedTextKit(
                  animatedTexts: [
                    textFunction('재테크', 50),
                    textFunction('아이티', 50),
                    textFunction('건강', 50),
                    textFunction('연예', 50),
                    textFunction('사회', 50),
                    textFunction('스포츠', 50),
                  ],
                  repeatForever: true,
                  pause: const Duration(milliseconds: 700),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 350,
          height: 100,
          child: Text(
            'TMI 뉴스 만들기',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFD43A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [TitleWidget(), KakaoLogin()],
        ),
      ),
    );
  }
}
