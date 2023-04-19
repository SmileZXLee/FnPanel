import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fn_panel/core/data/common_data.dart';

class FnGlobalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const FnGlobalButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  @override
  _FnGlobalButtonState createState() => _FnGlobalButtonState();
}

class DragSafeArea {
  double top;
  double left;
  double bottom;
  double right;

  DragSafeArea(this.top, this.left, this.bottom, this.right);
}

class _FnGlobalButtonState extends State<FnGlobalButton> {
  final Size _buttonSize = Size(60.0, 20.0);
  late final DragSafeArea _dragSafeArea = DragSafeArea(
    MediaQuery.of(context).padding.top + 20,
    20,
    MediaQuery.of(context).size.height - _buttonSize.height - MediaQuery.of(context).padding.bottom - 20,
    MediaQuery.of(context).size.width - _buttonSize.width - 20
  );

  late Offset _offset = CommonData.globalButtonOffset != null ? CommonData.globalButtonOffset! : Offset(_dragSafeArea.right, _dragSafeArea.bottom);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Draggable(
        feedback: _getGlobalButton(),
        child: GestureDetector(
          child: _getGlobalButton(),
          onTap: widget.onPressed,
        ),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          double dx = offset.dx;
          double dy = offset.dy;
          // 左边缘约束
          dx = max(dx, _dragSafeArea.left);
          // 右边缘约束
          dx = min(dx, _dragSafeArea.right);
          // 上边缘约束
          dy = max(dy, _dragSafeArea.top);
          // 下边缘约束
          dy = min(dy, _dragSafeArea.bottom);

          CommonData.globalButtonOffset = Offset(dx, dy);
          setState(() {
            _offset = Offset(dx, dy);
          });
        },
      ),
    );
  }

  Widget _getGlobalButton() {
    return Container(
      width: _buttonSize.width,
      height: _buttonSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: Colors.blue,
      ),

      child: Center(
        child: Text(
          "FN_PANEL",
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

}
