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
  var editMemoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
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
                          decoration: InputDecoration(
                            labelText: 'Write new memory here',
                            prefixIcon: Icon(
                              Icons.notes,
                              color: Colors.purple,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          child: Text('Save'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              box!.add(memoryController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'New memory " ${memoryController.text.substring(0, memoryController.text.length)} " Saved!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                              memoryController.clear();
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Remember the good times',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
                                        onTap: () {},
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

  // Define EditDialog Method
  EditDialog(String memory, int memoryKey) {
    editMemoryController.text = memory;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.purple.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.25,
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _editFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: editMemoryController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.center,
                      validator: (String? val) =>
                          val!.isNotEmpty ? null : 'Enter Memory',
                      decoration: InputDecoration(
                        labelText: 'Edit your memory below',
                        prefixIcon: Icon(
                          Icons.notes,
                          color: Colors.purple,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                )),
          ),
        );
      },
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
