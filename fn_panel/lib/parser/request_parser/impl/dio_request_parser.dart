import 'dart:async';
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
    String url = dioRequest.path;
    Uri uri = Uri.parse(url);
    String briefUrl = dioRequest.path.isEmpty ? "" : url.substring(url.lastIndexOf('/') + 1);
    String pathWithQuery = dioRequest.path.isEmpty ? "" : url.replaceFirst(uri.origin, "");
    if (briefUrl.isEmpty || briefUrl == "/") {
      briefUrl = uri.host;
    }
    if (pathWithQuery.isEmpty || pathWithQuery == "/") {
      pathWithQuery = uri.host;
    }
    dynamic body = dioRequest.data;
    FormDataModel? formDataModel;
    if (body is FormData) {
      FormData newFormData = FormData.fromMap({});
      newFormData.fields.addAll(List.of(body.fields));
      // newFormData.files.addAll(List.of(body.files));
      String formDataAsString = "";
      try {
        formDataAsString = await newFormData.finalize().transform(utf8.decoder).join();
      } catch (_) {}
      formDataModel = FormDataModel(
        newFormData.fields.map((entry) => { entry.key: entry.value }).toList(),
        List.of(body.files),
        newFormData.boundary,
        formDataAsString
      );
      body = null;
    }
    RequestModel requestModel = RequestModel(
      url,
      pathWithQuery,
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