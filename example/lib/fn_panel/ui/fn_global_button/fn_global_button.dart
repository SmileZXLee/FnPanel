import 'dart:math';
import 'package:flutter/material.dart';

import '../../data/common_data.dart';
import '../../config/fn_config.dart';

/// FnPanel
///
/// 全局按钮
class FnGlobalButton extends StatefulWidget {
  final VoidCallback onPressed;

  const FnGlobalButton({Key? key, required this.onPressed}) : super(key: key);

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
  final Size _buttonSize = Size(64.0, 20.0);
  DragSafeArea _dragSafeArea = DragSafeArea(0, 0, 0, 0);
  Offset _offset = Offset.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final FnGlobalButtonConfig? config = CommonData.config?.globalButtonConfig;

    double bottom = config?.bottom ?? 20.0;
    double right = config?.right ?? 20.0;

    _dragSafeArea = DragSafeArea(
        MediaQuery.of(context).padding.top + 20,
        20,
        MediaQuery.of(context).size.height - _buttonSize.height - MediaQuery.of(context).padding.bottom - bottom,
        MediaQuery.of(context).size.width - _buttonSize.width - right
    );
    setState(() {
      _offset = CommonData.globalButtonOffset != null ? CommonData.globalButtonOffset! : Offset(_dragSafeArea.right, _dragSafeArea.bottom);
      CommonData.globalButtonOffset = _offset;
    });
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
