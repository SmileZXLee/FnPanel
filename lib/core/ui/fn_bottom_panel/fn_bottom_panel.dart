import 'package:flutter/material.dart';
import 'package:fn_panel/core/data/common_data.dart';
import 'package:fn_panel/core/fn_panel.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/ui/base/fn_empty_text.dart';
import 'package:fn_panel/core/ui/fn_global_button/fn_global_button.dart';

import '../base/fn_base_bottom_panel.dart';
import 'fn_brief_panel/fn_brief_panel.dart';
import 'fn_detail_panel/fn_detail_panel.dart';

class FnBottomPanel extends Object {
  static BuildContext? _currentDialogContext;
  static BuildContext? _currentGlobalButtonContext;

  static OverlayEntry? _currentGlobalButton = null;

  static void show(BuildContext context,{String message = "loading..."}) async{
    if (_currentDialogContext == null) {
      _currentDialogContext = context;
      removeGlobalButton(_currentGlobalButtonContext);
      await showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          return FnBaseBottomPanel(
              child: FnBottomContentPanel()
          );
        },
      );
      addGlobalButton(_currentGlobalButtonContext);
      _currentDialogContext = null;
    }
  }

  static void dismiss(){
    if (_currentDialogContext != null) {
      Navigator.pop(_currentDialogContext!);
      _currentDialogContext = null;
    }
  }

  static void addGlobalButton(BuildContext? context) {
    if (_currentGlobalButton == null) {
      _currentGlobalButtonContext = context;
      final overlayState = Overlay.of(context!)!;
      _currentGlobalButton = OverlayEntry(
        builder: (BuildContext context) => FnGlobalButton(
          onPressed: () {
            show(context);
          },
          icon: Icons.add,
        ),
      );
      overlayState.insert(_currentGlobalButton!);
    }
  }

  static void removeGlobalButton(BuildContext? context) {
    if (_currentGlobalButton != null) {
      _currentGlobalButton!.remove();
      _currentGlobalButton = null;
    }
  }
}

class FnBottomContentPanel extends StatefulWidget {

  const FnBottomContentPanel({Key? key}) : super(key: key);

  @override
  _FnBottomContentPanelState createState() => _FnBottomContentPanelState();
}

class _FnBottomContentPanelState extends State<FnBottomContentPanel> {
  RequestModel? _requestModel;
  List<RequestModel> _requestList = CommonData.requestList;

  @override
  void initState() {
    super.initState();

    FnPanel.requestUpdateCallback = () {
      setState(() {
        _requestList = CommonData.requestList;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    FnPanel.requestUpdateCallback = null;
  }

  @override
  Widget build(BuildContext context) {
    double panelHeight = MediaQuery.of(context).size.height / 2.1 + MediaQuery.of(context).padding.bottom;
    return _requestList.isNotEmpty ? Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: panelHeight,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: FnBriefPanel(
                    requestList: _requestList,
                    onSelected: (RequestModel requestModel) {
                      setState(() {
                        _requestModel = requestModel;
                      });
                    },
                    onCleared: () {
                      setState(() {
                        _requestModel = null;
                        _requestList = [];
                      });
                    },
                  ),
                )
              ),
              Visibility(
                visible: _requestModel != null,
                child: Expanded(
                    flex: 3,
                    child: Container(
                      child: FnDetailPanel(requestModel: _requestModel, onClose: () {
                        setState(() {
                          _requestModel = null;
                        });
                      },),
                    )
                ),
              )
            ],
          ),
        ),
      ],
    ) : Container(
      height: panelHeight,
      child: FnEmptyText(text: "No Requests"),
    );
  }

}



