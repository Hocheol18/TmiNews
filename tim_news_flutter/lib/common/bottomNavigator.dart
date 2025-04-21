import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      style: CustomStyle(),
      child: ConvexAppBar(
        initialActiveIndex: currentIndex,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: Colors.black,
        activeColor: const Color(0xffFFD43A),
        items: [
          TabItem(icon: Icons.create, title: '생성'),
          TabItem(icon: CupertinoIcons.book, title: '보기'),
          TabItem(icon: Icons.person, title: '마이'),
        ],
        onTap: onTap,
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

  @override
  TextStyle textStyle(Color color, String? title) {
    return TextStyle(fontSize: 12, color: Colors.black);
  }
}
