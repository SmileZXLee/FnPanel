import 'dart:convert';

import '../export_parser.dart';
import '../../request_parser/model/request_model.dart';

/// FnPanel
///
/// 请求导出cUrl实现
class CurlExportParser extends ExportParser {
  @override
  String parser(RequestModel requestModel) {
    StringBuffer buffer = StringBuffer();
    buffer.write("curl -X ${requestModel.method} '${requestModel.url}'");

    requestModel.headers.forEach((key, value) {
      buffer.write(" -H '$key: $value'");
    });

    FormDataModel? formDataModel = requestModel.fromData;
    dynamic body = requestModel.data;
    String bodyStr = "";
    if (formDataModel != null) {
      bodyStr = formDataModel.asString;
    } else {
      try {
        bodyStr = body != null ? json.encode(body) : "";
      } catch (_) {}
    }

    if (bodyStr.isNotEmpty) {
      buffer.write(" -d '$bodyStr'");
    }

    return buffer.toString();
  }

}