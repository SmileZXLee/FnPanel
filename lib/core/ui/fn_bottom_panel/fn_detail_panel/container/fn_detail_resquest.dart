import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/third_party/flutter_json_viewer/flutter_json_viewer.dart';
import 'package:fn_panel/core/ui/base/fn_custom_expansion_tile.dart';
import 'package:fn_panel/core/ui/base/fn_empty_text.dart';
import 'package:fn_panel/core/utils/fn_print_utils.dart';

enum RequestType {
  body,
  query
}

/// FnPanel
///
/// FnPanel左侧请求详情-Request
class FnDetailRequest extends StatefulWidget {
  final RequestModel? requestModel;
  const FnDetailRequest({Key? key, this.requestModel}) : super(key: key);

  @override
  _FnDetailRequestState createState() => _FnDetailRequestState();
}

class _FnDetailRequestState extends State<FnDetailRequest> {
  bool _isQueryParsed = true;
  bool _isBodyParsed = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequestModel? requestModel = widget.requestModel;
    return requestModel != null ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRequestQuery(requestModel),
            _getRequestBody(requestModel)
          ],
        )
    ) : FnEmptyText(text: "No Request");
  }

  Widget _getRequestQuery(RequestModel requestModel){
    String url = requestModel.url;
    Uri uri = Uri.parse(url);
    Map<String, String> queryParameters = uri.queryParameters;
    return _getRequestExpansion(
        requestModel,
        RequestType.query,
        queryParameters.isNotEmpty,
        _isQueryParsed ? FnJsonViewer(queryParameters) :
        SelectableText(
          Uri(queryParameters: queryParameters).query,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.black
          ),
          onTap: () {
            FnPrintUtils.print(Uri(queryParameters: queryParameters).query);
          },
        )
    );
  }

  Widget _getRequestBody(RequestModel requestModel){
    return _getRequestExpansion(
        requestModel,
        RequestType.body,
        requestModel.data != null,
        _isBodyParsed && requestModel.data is Map ? FnJsonViewer(requestModel.data) :
        SelectableText(
          json.encode(requestModel.data),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.black
          ),
          onTap: () {
            FnPrintUtils.print(json.encode(requestModel.data));
          },
        )
    );
  }

  Widget _getRequestExpansion(RequestModel requestModel, RequestType type, bool visible, Widget child) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.zero,
        child: FnCustomExpansionTitle(
          title: Row(
            children: [
              Text(
                type == RequestType.body ? "Request Payload" : "Query String Params",
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 12.0,),
              GestureDetector(
                child: Text(
                  (type == RequestType.body ? _isBodyParsed : _isQueryParsed) ? "view parsed" : "view source",
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black87
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (type == RequestType.body) {
                      _isBodyParsed = !_isBodyParsed;
                    } else {
                      _isQueryParsed = !_isQueryParsed;
                    }
                  });
                },
              )
            ],
          ),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
