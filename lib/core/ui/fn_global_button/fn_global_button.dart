import 'package:flutter/material.dart';

class FnGlobalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const FnGlobalButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  @override
  _FnGlobalButtonState createState() => _FnGlobalButtonState();
}

class _FnGlobalButtonState extends State<FnGlobalButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          color: Colors.blue,
          child: Text(
            "Fn_Panel",
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.0
            ),
          ),
        ),
        onTap: widget.onPressed,
      ),
    );
  }
}

