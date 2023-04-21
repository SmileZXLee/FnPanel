import 'package:flutter/material.dart';

/// FnPanel
///
/// 自定义展开widget
class FnCustomExpansionTitle extends StatefulWidget {
  final Widget title;
  final List<Widget> children;

  const FnCustomExpansionTitle({required this.title, required this.children});

  @override
  _FnCustomExpansionTitleState createState() => _FnCustomExpansionTitleState();
}

class _FnCustomExpansionTitleState extends State<FnCustomExpansionTitle> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFF3F3F3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: Colors.black,
                    size: 16,
                  ),
                  SizedBox(
                      width: 2
                  ),
                  widget.title,
                ],
              ),
            ),
          ),
          if (_isExpanded) ...widget.children,
        ],
      ),
    );
  }
}
