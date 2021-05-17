import 'package:flutter/material.dart';
import 'package:src/screens/content_view.dart';
import 'package:src/widgets/widgets.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  List<ContentView> contentView = [
    ContentView(
      tab: CustomTab(
        title: 'Home',
      ),
      content: HomeContentView(),
    ),
    ContentView(
        tab: CustomTab(
          title: 'About',
        ),
        content: AboutContentView()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 720) {
            return desktopView();
          } else {
            return mobileView();
          }
        },
      ),
    );
  }

  Widget desktopView() {
    return Container();
  }

  Widget mobileView() {
    return Container();
  }
}
