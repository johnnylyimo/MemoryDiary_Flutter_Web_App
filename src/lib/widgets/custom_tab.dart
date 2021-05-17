import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String? title;

  const CustomTab({@required this.title});
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        this.title!,
        style: TextStyle(
          color: Colors.purple[700],
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}
