import 'dart:convert';

import 'package:fn_panel/core/parser/export_parser/export_parser.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';

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