import 'package:flutter/material.dart';

class TopNavigator extends StatelessWidget {
  const TopNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('재테크'),
        Text('IT'),
        Text('건강'),
        Text('사회'),
        Text('연애'),
        Text('스포츠'),
      ],
    );
  }
}
