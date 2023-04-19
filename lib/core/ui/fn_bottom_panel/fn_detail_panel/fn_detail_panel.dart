import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fn_panel/core/parser/export_parser/impl/curl_export_parser.dart';

import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/ui/fn_bottom_panel/fn_detail_panel/container/fn_detail_response.dart';
import 'package:fn_panel/core/utils/fn_print_utils.dart';

import 'container/fn_detail_headers.dart';
import 'container/fn_detail_resquest.dart';
import 'container/fn_detail_timing.dart';

/// FnPanel
///
/// FnPanel右侧请求详情面板
class FnDetailPanel extends StatefulWidget {
  final RequestModel? requestModel;
  final Function? onClose;
  const FnDetailPanel({Key? key, this.requestModel, this.onClose}) : super(key: key);
  @override
  _FnDetailPanelState createState() => _FnDetailPanelState();
}

class _FnDetailPanelState extends State<FnDetailPanel> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Headers', 'Request', 'Response', 'Timing'];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 17.0,
                  color: Colors.black54,
                ),
              ),
              onTap: () {
                widget.onClose!();
              },
            ),
            for (int i = 0; i < _tabs.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _onTabSelected(i);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: _selectedIndex == i ? Colors.blue : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _tabs[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: widget.requestModel != null,
              child: PopupMenuButton<String>(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(Icons.more_vert, size: 16.0, color: Colors.black54),
                ),
                padding: EdgeInsets.zero,
                onSelected: (String value) {
                  if (value == "curl") {
                    CurlExportParser exportParser = CurlExportParser();
                    String result = exportParser.parser(widget.requestModel!);
                    Clipboard.setData(ClipboardData(text: result));
                    FnPrintUtils.printDebug(result);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      height: 20.0,
                      value: 'curl',
                      child: Text('Copy as cURL', style: TextStyle(fontSize: 12.0),),
                    ),
                  ];
                },
              ),
            )
            ,
          ],
        ),
        Expanded(
          child: _buildContent(widget.requestModel),
        ),
      ],
    );
  }

  Widget _buildContent(RequestModel? requestModel) {
    switch (_selectedIndex) {
      case 0:
        return FnDetailHeaders(requestModel: requestModel);
      case 1:
        return FnDetailRequest(requestModel: requestModel);
      case 2:
        return FnDetailResponse(requestModel: requestModel);
      case 3:
        return FnDetailTiming(requestModel: requestModel);
      default:
        return Container();
    }
  }
}
