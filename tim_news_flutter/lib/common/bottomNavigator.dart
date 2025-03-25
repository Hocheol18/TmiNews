import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class bottomNavigator extends StatelessWidget {
  const bottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      style: CustomStyle(),
      child: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: Colors.black,
        activeColor: Colors.yellow,
        items: [
          TabItem(icon: Icons.create, title: '생성'),
          TabItem(icon: CupertinoIcons.book, title: '보기'),
          TabItem(icon: Icons.person, title: '마이'),
        ],
      ),
    );
  }
}

class CustomStyle extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 5;

  @override
  double get iconSize => 25;

  Color activeIconColor(Color color) {
    // 활성화된 아이콘 색상을 검은색으로 설정
    return Colors.black;
  }

  @override
  TextStyle textStyle(Color color, String? title) {
    // Override the text color to always be black regardless of the provided color
    return TextStyle(fontSize: 12, color: Colors.black);
  }
}
