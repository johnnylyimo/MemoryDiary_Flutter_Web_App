import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabBarScaling = screenWidth > 1400
        ? 0.21
        : screenWidth > 1100
            ? 0.3
            : 0.4;
    // if is between 1400 and 1100 is 0.3 and else small than that 0.4
    return Container(
      width: screenWidth * tabBarScaling,
      child: TabBar(
        controller: controller,
        tabs: this.tabs,
      ),
    );
  }
}
