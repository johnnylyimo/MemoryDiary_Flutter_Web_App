import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:src/screens/screens.dart';
import 'package:src/widgets/widgets.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  TabController? tabController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ItemScrollController? itemScrollController;
  double? screenWidth;
  double? screenHeight;
  List<ContentView> contentView = [
    ContentView(
        tab: CustomTab(
          title: 'Home',
        ),
        content: HomeContentView()),
    // ContentView(
    //   tab: CustomTab(
    //     title: 'About',
    //   ),
    //   content: AboutContentView(),
    // ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: contentView.length, vsync: this);
    itemScrollController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: drawer(context),
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
        Expanded(
          child: Container(
            // height: screenHeight! * 0.9,
            child: TabBarView(
              controller: tabController,
              children: contentView.map((e) => e.content).toList(),
            ),
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
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: contentView.length,
              itemBuilder: (context, index) {
                //    Control mobile view body 
                return Container(
                  child: contentView[index].content,
                  height: screenWidth! < 571 ? 1380:1150,
                  margin: EdgeInsets.only(bottom: 5.0),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.purple.shade100,
        child: ListView(
          children: [
                Align(
                  alignment: Alignment(0.9, -0.5),
                  child: IconButton(
                    hoverColor: Colors.transparent,
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
                        onTap: () {
                          itemScrollController!.scrollTo(
                            index: contentView.indexOf(e),
                            duration: Duration(milliseconds: 300),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
