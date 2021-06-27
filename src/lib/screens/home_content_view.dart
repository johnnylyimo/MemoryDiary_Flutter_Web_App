import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeContentView extends StatefulWidget {
  @override
  _HomeContentViewState createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  double? screenWidth;
  double? screenHeight;
  Box? box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('memoryBox');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) {
          return desktopView();
        } else {
          return mobileView();
        }
      },
    );
  }

  Widget desktopView() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 360.0,
            color: Colors.purple.shade200,
            padding: EdgeInsets.all(5.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'WORD OF THE DAY\n',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Today will be better than yesterday',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Flexible(
            child: Container(
              width: 700.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hightlights',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mobileView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth! * 0.45,
              color: Colors.purple.shade200,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              padding: EdgeInsets.all(20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'WORD OF THE DAY\n',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Today will be better than yesterday',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            'Highlights',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
