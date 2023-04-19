import 'package:fn_panel/core/utils/fn_time_utils.dart';

import '../model/request_model.dart';

import '../request_parser.dart';
import 'package:dio/dio.dart';

/// FnPanel
///
/// dio Request解析实现
class DioRequestParser implements RequestParser {
  @override
  RequestModel parser(dynamic request) {
    RequestOptions dioRequest  = request as RequestOptions;
    String path = dioRequest.path;
    String briefUrl = dioRequest.path.isEmpty ? "" : path.substring(path.lastIndexOf('/') + 1);
    RequestModel requestModel = RequestModel(
      dioRequest.path,
      briefUrl,
      dioRequest.method,
      -1,
      dioRequest.headers,
      dioRequest.data,
      null,
      dioRequest,
      FnTimeUtils.getTimestamp()
    );
    return requestModel;
  }

}