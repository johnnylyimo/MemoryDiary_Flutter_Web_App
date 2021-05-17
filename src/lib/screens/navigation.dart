import 'package:flutter/material.dart';
import 'package:src/screens/content_view.dart';
import 'package:src/widgets/widgets.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  TabController tabController;
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
      content: AboutContentView(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: contentView.length, vsync: this);
  }

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  Widget mobileView() {
    return Container();
  }
}
