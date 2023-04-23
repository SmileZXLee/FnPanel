import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../parser/request_parser/model/request_model.dart';
import '../../../../third_party/flutter_json_viewer/flutter_json_viewer.dart';
import '../../../../ui/base/fn_custom_expansion_tile.dart';
import '../../../../ui/base/fn_empty_text.dart';
import '../../../../utils/fn_print_utils.dart';

enum RequestType {
  body,
  query,
  formData
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
  bool _isFormDataParsed = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequestModel? requestModel = widget.requestModel;
    return !_isAllEmpty(requestModel)  ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRequestQuery(requestModel!),
            _getRequestBody(requestModel!),
            _getFormDataBody(requestModel!)
          ],
        )
    ) : FnEmptyText(text: "No Query String Or Request Content");
  }

  Widget _getRequestQuery(RequestModel requestModel){
    String url = requestModel.url;
    Uri uri = Uri.parse(url);
    Map<String, String> queryParameters = uri.queryParameters;
    return _getRequestExpansion(
        requestModel: requestModel,
        type: RequestType.query,
        title: "Query String Params",
        isParsed: _isQueryParsed,
        visible: queryParameters.isNotEmpty,
        child: _isQueryParsed ? FnJsonViewer(queryParameters) :
        SelectableText(
          Uri(queryParameters: queryParameters).query,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.black
          ),
          onTap: () {
            FnPrintUtils.printMsg(Uri(queryParameters: queryParameters).query);
          },
        )
    );
  }

  Widget _getRequestBody(RequestModel requestModel){
    String bodyStr = "";
    try {
      bodyStr = json.encode(requestModel.data);
    } catch (e) {
      bodyStr = requestModel.data.runtimeType.toString();
    }
    return _getRequestExpansion(
        requestModel: requestModel,
        type: RequestType.body,
        title: "Request Payload",
        isParsed: _isBodyParsed,
        visible: requestModel.data != null,
        child: _isBodyParsed && requestModel.data is Map ? FnJsonViewer(requestModel.data) :
        SelectableText(
          bodyStr,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.black
          ),
          onTap: () {
            FnPrintUtils.printMsg(json.encode(requestModel.data));
          },
        )
    );
  }

  Widget _getFormDataBody(RequestModel requestModel){
    FormDataModel? formDataModel = requestModel.fromData;
    List<Map<String, String>> fields = formDataModel?.fields ?? [];
    List<MapEntry<String, MultipartFile>> files = formDataModel?.files ?? [];
    List<Map<String, String>> briefFiles = files.map((file) => {file.key: "(binary)"}).toList();
    List<Map<String, String>> totalFields = [...briefFiles, ...fields];

    return _getRequestExpansion(
        requestModel: requestModel,
        type: RequestType.formData,
        title: "Form Data",
        isParsed: _isFormDataParsed,
        visible: formDataModel != null,
        child: _isFormDataParsed ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: totalFields.map((field) => FnJsonViewer(field)).toList(),
        ) :
        (formDataModel?.asString ?? "").isNotEmpty ? SelectableText(
          formDataModel?.asString ?? "",
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.black
          ),
          onTap: () {
            FnPrintUtils.printMsg(formDataModel?.asString ?? "");
          },
        ) : FnEmptyText(text: "No Source")
    );
  }

  Widget _getRequestExpansion({
    required RequestModel requestModel, required RequestType type,
    required String title, required bool isParsed, required bool visible, required Widget child
  }) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.zero,
        child: FnCustomExpansionTitle(
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 12.0,),
              GestureDetector(
                child: Text(
                  isParsed ? "view source" : "view parsed",
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black87
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (type == RequestType.body) {
                      _isBodyParsed = !_isBodyParsed;
                    } else if (type == RequestType.query) {
                      _isQueryParsed = !_isQueryParsed;
                    } else if (type == RequestType.formData) {
                      _isFormDataParsed = !_isFormDataParsed;
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

  bool _isAllEmpty(RequestModel? requestModel) {
    if (requestModel == null) {
      return true;
    }
    Map<String, String> queryParameters = Uri.parse(requestModel.url).queryParameters;
    return queryParameters.isEmpty && requestModel!.data == null && requestModel!.fromData == null;
  }
}
