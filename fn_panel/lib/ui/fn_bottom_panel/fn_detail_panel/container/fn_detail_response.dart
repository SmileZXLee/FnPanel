import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../parser/request_parser/model/request_model.dart';
import '../../../../parser/response_parser/model/response_model.dart';
import '../../../../third_party/flutter_json_viewer/flutter_json_viewer.dart';
import '../../../../ui/base/fn_custom_expansion_tile.dart';
import '../../../../ui/base/fn_empty_text.dart';
import '../../../../utils/fn_print_utils.dart';

/// FnPanel
///
/// FnPanel左侧请求详情-Response
class FnDetailResponse extends StatefulWidget {
  final RequestModel? requestModel;
  const FnDetailResponse({Key? key, this.requestModel}) : super(key: key);

  @override
  _FnDetailResponseState createState() => _FnDetailResponseState();
}

class _FnDetailResponseState extends State<FnDetailResponse> {
  bool _isParsed = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponseModel? responseModel = widget.requestModel?.response;
    String bodyStr = "";
    try {
      bodyStr = responseModel != null ? json.encode(responseModel.data) : "";
    } catch (_) {}

    return responseModel != null ? SingleChildScrollView(
      scrollDirection: Axis.vertical, // 设置滚动方向为垂直方向
      child: Container(
        padding: EdgeInsets.zero,
        child: FnCustomExpansionTitle(
          title: Row(
            children: [
              const Text(
                "Response Payload",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(width: 12.0,),
              GestureDetector(
                child: Text(
                  _isParsed ? "view source" : "view parsed",
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Colors.black87
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isParsed = !_isParsed;
                  });
                },
              )
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _isParsed ? (responseModel.data is Map ? FnJsonViewer(responseModel.data) : const FnEmptyText(text: "No Preview")) :
              bodyStr.isNotEmpty ? SelectableText(
                bodyStr,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                ),
                onTap: () {
                  FnPrintUtils.printMsg(json.encode(responseModel.data));
                },
              ) : const FnEmptyText(text: "No Source")
            )
          ],
        ),
      )
    ) : const FnEmptyText(text: "No Response");
  }
}
