import 'package:flutter/material.dart';

/// FnPanel
///
/// 通用空数据Text
class FnEmptyText extends StatefulWidget {
  final String text;

  const FnEmptyText({Key? key, required this.text}) : super(key: key);

  @override
  _FnEmptyTextState createState() => _FnEmptyTextState();
}

class _FnEmptyTextState extends State<FnEmptyText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
