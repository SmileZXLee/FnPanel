import 'package:flutter/material.dart';
import '../../data/common_data.dart';
import '../../parser/request_parser/model/request_model.dart';
import '../../ui/base/fn_empty_text.dart';
import '../fn_global_button/fn_global_button.dart';

import '../base/fn_base_bottom_panel.dart';
import 'fn_brief_panel/fn_brief_panel.dart';
import 'fn_detail_panel/fn_detail_panel.dart';

class FnBottomPanel extends Object {
  static bool _isAddedGlobalButton = false;

  static BuildContext? _currentDialogContext;
  static OverlayState? _currentOverlayState;

  static OverlayEntry? _currentGlobalButton;

  /// 显示FnPanel
  ///
  /// context
  /// Returns void
  static void show(BuildContext context) {
    if (_currentDialogContext == null) {
      Future.delayed(const Duration(milliseconds: 10), () async{
        _currentDialogContext = context;
        if (_isAddedGlobalButton) {
          _removeGlobalButton();
        }

        await showDialog(
          context: context,
          useSafeArea: false,
          builder: (BuildContext context) {
            return const FnBaseBottomPanel(
                child: FnBottomContentPanel()
            );
          },
        );

        if (_isAddedGlobalButton) {
          Future.delayed(const Duration(milliseconds: 100), () {
            addGlobalButton(context);
          });
        }
        _currentDialogContext = null;
      });
    }
  }

  /// 关闭FnPanel
  ///
  ///
  /// Returns void
  static void dismiss(){
    if (_currentDialogContext != null) {
      Navigator.pop(_currentDialogContext!);
      _currentDialogContext = null;
    }
  }

  /// 添加全局按钮
  ///
  /// context
  /// Returns void
  static void addGlobalButton(BuildContext? context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (_currentGlobalButton == null && context != null) {
        _isAddedGlobalButton = true;

        OverlayState overlayState;
        if (_currentOverlayState == null) {
          overlayState = Overlay.of(context);
          _currentOverlayState = overlayState;
        } else {
          overlayState = _currentOverlayState!;
        }
        _currentGlobalButton = OverlayEntry(
          maintainState: true,
          builder: (BuildContext context) => FnGlobalButton(
              onPressed: () {
                show(context);
              }
          ),
        );
        overlayState.insert(_currentGlobalButton!);
      }
    });
  }

  /// 移除全局按钮
  ///
  ///
  /// Returns void
  static void removeGlobalButton() {
    if (_currentGlobalButton != null) {
      _isAddedGlobalButton = false;
      _currentGlobalButton!.remove();
      _currentGlobalButton = null;
    }
  }

  /// 移除全局按钮(私有)
  ///
  ///
  /// Returns void
  static void _removeGlobalButton() {
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
  Key _detailPanelKey = UniqueKey();
  @override
  void initState() {
    super.initState();

    CommonData.requestUpdateCallback = () {
      setState(() {
        _requestList = CommonData.requestList;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    CommonData.requestUpdateCallback = null;
  }

  @override
  Widget build(BuildContext context) {
    double panelHeight = MediaQuery.of(context).size.height / 2.1 + MediaQuery.of(context).padding.bottom;
    return _requestList.isNotEmpty ? Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: panelHeight,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: FnBriefPanel(
                  requestList: _requestList,
                  onSelected: (RequestModel requestModel) {
                    setState(() {
                      _detailPanelKey = UniqueKey();
                      _requestModel = requestModel;
                    });
                  },
                  onCleared: () {
                    setState(() {
                      _requestModel = null;
                      _requestList = [];
                    });
                  },
                  isExpanded: _requestModel == null
                )
              ),
              Visibility(
                visible: _requestModel != null,
                child: Expanded(
                    flex: 3,
                    child: FnDetailPanel(key: _detailPanelKey, requestModel: _requestModel, onClose: () {
                      setState(() {
                        _requestModel = null;
                      });
                    },)
                ),
              )
            ],
          ),
        ),
      ],
    ) : SizedBox(
      height: panelHeight,
      child: const FnEmptyText(text: "No Requests"),
    );
  }

}



