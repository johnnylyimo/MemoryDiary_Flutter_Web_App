import 'package:flutter/material.dart';
import 'package:src/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MemoryDiary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NavigationBar());
  }
}
