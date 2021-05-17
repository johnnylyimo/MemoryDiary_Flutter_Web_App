import 'package:flutter/material.dart';
import 'package:src/screens/content_view.dart';
import 'package:src/widgets/widgets.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  double? screenWidth;
  double? screenHeight;
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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTabBar(
          controller: tabController!,
          tabs: contentView.map((e) => e.tab).toList(),
        ),
        Container(
          height: screenHeight! * 0.8,
          child: TabBarView(
            controller: tabController,
            children: contentView.map((e) => e.content).toList(),
          ),
        )
      ],
    );
  }

  Widget mobileView() {
    return Container(
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded),
            iconSize: screenWidth! * 0.08,
            color: Colors.purple[700],
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer();
  }
}
