import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeContentView extends StatefulWidget {
  @override
  _HomeContentViewState createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  double? screenWidth;
  double? screenHeight;
  var memoryController = TextEditingController();
  var editMemoryController = TextEditingController();
  var addNewMemoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final _addNewMemoryFormKey = GlobalKey<FormState>();
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
            height: 220.0,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('Delete'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                          ),
                          onPressed: () {
                            box!.delete(memoryKey);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'The memory " ${editMemoryController.text.substring(0, editMemoryController.text.length)} " Already been Deleted!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                          child: Text('Save'),
                          onPressed: () {
                            if (_editFormKey.currentState!.validate()) {
                              box!.put(memoryKey, editMemoryController.text);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'The memory " ${editMemoryController.text.substring(0, editMemoryController.text.length)} " Edited Successfully!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  // Add new memory
  addNewMemoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.purple.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 220.0,
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _addNewMemoryFormKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: addNewMemoryController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.center,
                    validator: (String? val) =>
                        val!.isNotEmpty ? null : 'Enter Memory',
                    decoration: InputDecoration(
                      labelText: 'Add your memory below',
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
                      if (_addNewMemoryFormKey.currentState!.validate()) {
                        box!.add(addNewMemoryController.text);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'New memory " ${addNewMemoryController.text.substring(0, addNewMemoryController.text.length)} " Saved!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        addNewMemoryController.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Footer widget
  Widget footer({bool? isMobile}) {
    return Container(
      height: isMobile! ? 720.0 : 260.0,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.13),
      ),
      child: isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image(
                      image: AssetImage('images/logo.PNG'),
                      width: 160.0,
                      height: 114.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "MolysTechie is tech startup, specialized on developing Mobile Apps, Web Apps and Wep APIs. It's senior Developer is John L. Lyimo, the guy who developed this Website that is powered by Flutter and hosted on GitHub pages.",
                      textAlign: TextAlign.center,
                      maxLines: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Follow me
                Column(
                  children: [
                    Text(
                      'Follow Me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      child: Text(
                        'Github',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: () =>
                          _launchURL('https://github.com/johnnylyimo'),
                    ),
                    TextButton(
                      child: Text(
                        'Twitter',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: () =>
                          _launchURL('https://twitter.com/johnnylyimo'),
                    ),
                    TextButton(
                      child: Text(
                        'LinkedIn',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: () =>
                          _launchURL('https://www.linkedin.com/in/johnnylyimo'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Find me
                Column(
                  children: [
                    Text(
                      'Find Me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.place),
                        Flexible(
                          child: Text(
                            'Buni at Costech Building, Sayansi, Dar-es-Salaam.',
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Contact me
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_phone,
                        ),
                        Flexible(
                          child: Text(' 0715 291029'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email),
                        Flexible(
                          child: Text(' molystechie@gmail.com'),
                        ),
                      ],
                    ),
                  ],
                ),
                //brand name
                Divider(
                  color: Colors.purple,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '??',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                    children: [
                      TextSpan(
                        text: '2021 ',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        children: [
                          TextSpan(
                            text: 'MolysTechie. All Rights Reserved',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          // >>>>DESKTOP FOOTER
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('images/logo.PNG'),
                            width: 160.0,
                            height: 114.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "MolysTechie is tech startup, specialized on developing Mobile Apps, Web Apps and Wep APIs. It's senior Developer is John L. Lyimo, the guy who developed this Website that is powered by Flutter and hosted on GitHub pages.",
                            textAlign: TextAlign.center,
                            maxLines: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 238.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Follow Me',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Github',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        onPressed: () => _launchURL(
                                            'https://github.com/johnnylyimo'),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Twitter',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        onPressed: () => _launchURL(
                                            'https://twitter.com/johnnylyimo'),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'LinkedIn',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        onPressed: () => _launchURL(
                                            'https://www.linkedin.com/in/johnnylyimo'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 60.0,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Find Me',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.place),
                                          Flexible(
                                            child: Text(
                                              'Buni at Costech Building, Sayansi, Dar-es-Salaam.',
                                              textAlign: TextAlign.center,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Contact Me',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_phone,
                                          ),
                                          Flexible(
                                            child: Text(' 0715 291029'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.email),
                                          Flexible(
                                            child:
                                                Text(' molystechie@gmail.com'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.purple,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '??',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: '2021 ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'MolysTechie. All Rights Reserved',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Widget desktopView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 420.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
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
                                color: Colors.black),
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
                                      borderSide:
                                          BorderSide(color: Colors.purple),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                ElevatedButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      box!.add(memoryController.text);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                  height: 5.0,
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
                                                memories.values
                                                    .elementAt(index),
                                                maxLines: 2,
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () => EditDialog(
                                                  memories.values
                                                      .elementAt(index),
                                                  memories.keys
                                                      .elementAt(index),
                                                ),
                                              ),
                                              onTap: () => EditDialog(
                                                memories.values
                                                    .elementAt(index),
                                                memories.keys.elementAt(index),
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
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(child: footer(isMobile: false)),
        ],
      ),
    );
  }

  // Mobile screen view
  Widget mobileView() {
    return Container(
      width: double.infinity,
      height: screenHeight,
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
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Today will be better than yesterday',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Highlights',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Column(
                children: [
                  Text('Add New Memory'),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () => addNewMemoryDialog(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            // << REMOVED WRAPPED EXPANDED
            height: 240.0,
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
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => EditDialog(
                                    memories.values.elementAt(index),
                                    memories.keys.elementAt(index),
                                  ),
                                ),
                                onTap: () => EditDialog(
                                  memories.values.elementAt(index),
                                  memories.keys.elementAt(index),
                                ),
                              ),
                            );
                          },
                        )
                      : Text(
                          'No Memory\nAdd your memory by click plus button above');
                }),
          ),
          SizedBox(
            height: 20.0,
          ),
          footer(isMobile: true)
        ],
      ),
    );
  }
}
