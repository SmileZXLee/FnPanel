import 'dart:convert';

import '../../../parser/export_parser/export_parser.dart';
import '../../../parser/request_parser/model/request_model.dart';

/// FnPanel
///
/// 请求导出cUrl实现
class CurlExportParser extends ExportParser {
  @override
  String parser(RequestModel requestModel) {
    StringBuffer buffer = new StringBuffer();
    buffer.write("curl -X ${requestModel.method} '${requestModel.url}'");

    requestModel.headers.forEach((key, value) {
      buffer.write(" -H '$key: $value'");
    });

    if (requestModel.data != null) {
      buffer.write(" -d '${json.encode(requestModel.data)}'");
    }

    return buffer.toString();
  }

}