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
  var scaffoldKey = GlobalKey<ScaffoldState>();
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
      endDrawer: drawer(),
      key: scaffoldKey,
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
      padding: EdgeInsets.only(right: 20.0, top: 20.0),
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded),
            iconSize: screenWidth! * 0.08,
            color: Colors.purple[700],
            onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
              Align(
                alignment: Alignment(0.9, -0.5),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 48.0,
                    color: Colors.purple[700],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // add top space with empty container
              Container(
                height: screenHeight! * 0.1,
              ),
            ] +
            contentView
                .map(
                  (e) => Container(
                    child: ListTile(
                      title: Text(e.tab.title!),
                      onTap: () {},
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
