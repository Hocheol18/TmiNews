import 'package:flutter/material.dart';
import 'dart:math' as math;


// 글 블록, 색은 4가지 중 랜덤으로
// content에 내용, link에 연결된 링크 담아서 보내면 됩니다.
// todo: 눌렀을 때, 해당 글 링크로 보내줄 예정
class ArticleBlock extends StatelessWidget {
  const ArticleBlock({super.key, this.content, this.link});
  final content;
  final link;

  @override
  Widget build(BuildContext context) {
    // 랜덤 색상 생성
    final random = math.Random();
    final colorList = [
      Color(0xFF96E5FF),
      Color(0xFFA5B2FF),
      Color(0xFFFFD3D3),
      Color(0xFFEFEEB1)
    ];
    final randomPredefinedColor = colorList[random.nextInt(colorList.length)];

    return Container(
      decoration: BoxDecoration(
        color: randomPredefinedColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          content,
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 3
        ),
      ),
    );
  }
}


