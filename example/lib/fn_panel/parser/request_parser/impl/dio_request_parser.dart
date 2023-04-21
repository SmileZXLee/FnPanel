import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../utils/fn_time_utils.dart';
import '../model/request_model.dart';
import '../request_parser.dart';

/// FnPanel
///
/// dio Request解析实现
class DioRequestParser implements RequestParser {
  @override
  Future<RequestModel> parser(dynamic request) async{
    RequestOptions dioRequest  = request as RequestOptions;
    String path = dioRequest.path;
    String briefUrl = dioRequest.path.isEmpty ? "" : path.substring(path.lastIndexOf('/') + 1);
    dynamic body = dioRequest.data;
    FormDataModel? formDataModel;
    if (body is FormData) {
      FormData formData = body;
      body = null;
      String formDataAsString = "";
      try {
        formDataAsString = await formData.finalize().transform(utf8.decoder).join();
      } catch (_) {}
      formDataModel = FormDataModel(
        formData.fields.map((entry) => { entry.key: entry.value }).toList(),
        formData.files, formData.boundary,
        formDataAsString
      );
    }
    RequestModel requestModel = RequestModel(
      dioRequest.path,
      briefUrl,
      dioRequest.method,
      -1,
      dioRequest.headers,
      body,
      formDataModel,
      null,
      dioRequest,
      FnTimeUtils.getTimestamp()
    );
    return requestModel;
  }
}