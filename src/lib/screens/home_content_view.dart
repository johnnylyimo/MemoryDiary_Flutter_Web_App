import 'package:flutter/material.dart';

class HomeContentView extends StatefulWidget {
  @override
  _HomeContentViewState createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  double? screenWidth;
  double? screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body:LayoutBuilder(
        builder:(context, constraints) {
          if (constraints.maxWidth > 720) {
            return desktopView();
          } else {
            return mobileView();
          }
        },
      )
    );
  }
}
