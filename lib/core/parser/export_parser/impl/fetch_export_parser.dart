import 'dart:convert';

import 'package:fn_panel/core/parser/export_parser/export_parser.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';

class FetchExportParser extends ExportParser {
  @override
  String parser(RequestModel requestModel) {
    final headers = requestModel.headers.entries.map((e) => '    "${e.key}": "${e.value}",').join('\n');
    final body = requestModel.data != null ? '    body: "${json.encode(requestModel.data)}",' : '';

    return '''fetch("${requestModel.url}", {
    method: "${requestModel.method}",
    headers: {
      $headers
    },
      $body
    }).then(response => response.text())
      .then(text => console.log(text))
      .catch(error => console.error(error));''';
  }



}