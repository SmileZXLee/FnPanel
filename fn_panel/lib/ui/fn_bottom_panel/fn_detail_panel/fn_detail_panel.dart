import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/common_data.dart';
import '../../../parser/export_parser/export_parser.dart';
import '../../../parser/export_parser/impl/curl_export_parser.dart';
import '../../../parser/export_parser/impl/fetch_export_parser.dart';
import '../../../parser/request_parser/model/request_model.dart';
import '../../../ui/fn_bottom_panel/fn_detail_panel/container/fn_detail_response.dart';
import '../../../utils/fn_print_utils.dart';

import './container/fn_detail_headers.dart';
import './container/fn_detail_request.dart';
import './container/fn_detail_timing.dart';

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
  int _selectedIndex = CommonData.requestDetailPanelTabIndex;
  final List<String> _tabs = ['Headers', 'Request', 'Response', 'Timing'];

  void _onTabSelected(int index) {
    CommonData.requestDetailPanelTabIndex = index;
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
                padding: const EdgeInsets.all(4),
                child: const Icon(
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
                          style: const TextStyle(
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
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: const Icon(Icons.more_vert, size: 16.0, color: Colors.black54),
                ),
                padding: EdgeInsets.zero,
                onSelected: (String value) {
                  ExportParser? exportParser;
                  if (value == "curl") {
                    exportParser = CurlExportParser();
                  } else if (value == "fetch") {
                    exportParser = FetchExportParser();
                  }
                  if (exportParser != null) {
                    String result = exportParser.parser(widget.requestModel!);
                    Clipboard.setData(ClipboardData(text: result));
                    FnPrintUtils.printMsg(result);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      height: 22.0,
                      value: 'curl',
                      child: Text('Copy as cURL', style: TextStyle(fontSize: 12.0),),
                    ),
                    const PopupMenuItem<String>(
                      height: 22.0,
                      value: 'fetch',
                      child: Text('Copy as fetch', style: TextStyle(fontSize: 12.0),),
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
