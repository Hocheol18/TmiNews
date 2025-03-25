import 'package:flutter/material.dart';
import '../common/bottomNavigator.dart';
import '../common/topNavigator.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar'),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: TopNavigator(),
          ),
        ),
      ),
      body: Text('Main'),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
