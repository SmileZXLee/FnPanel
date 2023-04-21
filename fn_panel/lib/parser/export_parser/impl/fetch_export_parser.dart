import 'dart:convert';

import '../export_parser.dart';
import '../../request_parser/model/request_model.dart';

/// FnPanel
///
/// 请求导出fetch实现
class FetchExportParser extends ExportParser {
  @override
  String parser(RequestModel requestModel) {
    final headers = requestModel.headers.entries.map((e) => '    "${e.key}": "${e.value}",').join('\n');
    FormDataModel? formDataModel = requestModel.fromData;

    String bodyStr = "";
    if (formDataModel != null) {
      bodyStr = formDataModel.asString;
    } else {
      try {
        bodyStr = requestModel.data != null ? json.encode(requestModel.data) : "";
      } catch (_) {}
    }

    final body = bodyStr.isNotEmpty ? '    body: "$bodyStr",' : '';

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