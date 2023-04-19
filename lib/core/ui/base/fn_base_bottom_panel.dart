import 'package:flutter/material.dart';

/// FnPanel
///
/// 通用底部弹出widget
class FnBaseBottomPanel extends StatefulWidget {
  final Widget child;

  FnBaseBottomPanel({Key? key, required this.child}) : super(key: key);

  @override
  _FnBaseBottomPanelState createState() => _FnBaseBottomPanelState();
}

class _FnBaseBottomPanelState extends State<FnBaseBottomPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reverse().then((value) => Navigator.pop(context));
      },
      child: Material(
        type: MaterialType.transparency,
        child: SlideTransition(
          position: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: widget.child,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}





