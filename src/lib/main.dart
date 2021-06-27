import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:src/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.openBox('memoryBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MemoryDiary',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.purple.shade100,
        ),
        home: NavigationBar());
  }
}
