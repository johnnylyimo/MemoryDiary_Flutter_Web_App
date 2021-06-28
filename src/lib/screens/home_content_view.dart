import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeContentView extends StatefulWidget {
  @override
  _HomeContentViewState createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  double? screenWidth;
  double? screenHeight;
  var memoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'WORD OF THE DAY\n',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Today will be better than yesterday',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Anytime something positive happens, make a note of it and come back to it later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: memoryController,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textAlign: TextAlign.left,
                          validator: (String? val) =>
                              val!.isNotEmpty ? null : 'Enter Memory',
                          decoration: InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      child: ValueListenableBuilder(
                        valueListenable: box!.listenable(),
                        builder: (context, Box _box, _) {
                          return _box.length != 0
                              ? ListView.builder(
                                  itemCount: _box.length,
                                  itemBuilder: (context, index) {
                                    var memories = _box.toMap();
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.notes),
                                        title: Text(
                                          memories.values.elementAt(index),
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Text(
                                  'No Memory\nAdd your memory by click plus button below');
                        },
                      ),
                    ),
                  )
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
