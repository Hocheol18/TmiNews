import 'package:flutter/material.dart';

import 'common/bottomNavigator.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appbar'),),
      body: Text('Main'),
      bottomNavigationBar: bottomNavigator(),
    );
  }
}
