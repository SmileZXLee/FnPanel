import 'package:flutter/material.dart';
import 'package:fn_panel/core/data/common_data.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/utils/fn_text_utils.dart';

class FnBriefPanel extends StatefulWidget {
  final List<RequestModel>? requestList;
  final Function(RequestModel)? onSelected;
  final Function()? onCleared;
  const FnBriefPanel({Key? key, this.requestList, this.onSelected, this.onCleared}) : super(key: key);
  @override
  _FnBriefPanelState createState() => _FnBriefPanelState();
}

class _FnBriefPanelState extends State<FnBriefPanel> {
  int _selectedIndex = -1;
  List<RequestModel> _requestList = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.requestList != null) {
      _requestList = widget.requestList!;
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _requestList.isNotEmpty,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 0.5,
              color: Color(0xFFF3F3F3),
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0, right: 6.0),
                    child: Stack(
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            child: Icon(
                              Icons.not_interested,
                              color: Colors.black54,
                              size: 15.0,
                            ),
                            onTap: () {
                              _doClearAll();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _requestList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String title = _requestList[index].briefUrl.isNotEmpty ? _requestList[index].briefUrl : "UNKNOWN";
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          if (widget.onSelected != null) {
                            widget.onSelected!(_requestList[index]);
                          }
                        },
                        child: Container(
                          color: _selectedIndex == index ? Colors.blue : (index % 2 == 0 ? null : const Color(0xFFF3F3F3)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                            child: Text(
                              FnTextUtils.breakWord(title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: _selectedIndex == index ? Colors.white : Colors.black
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  void _doClearAll() {
    CommonData.requestList = [];
    CommonData.requestingMap = {};
    setState(() {
      _requestList = [];
    });
    if (widget.onCleared != null) {
      widget.onCleared!();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 10),
        curve: Curves.linear,
      );
    });
  }

}
