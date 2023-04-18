import 'package:fn_panel/core/parser/response_parser/model/response_model.dart';

/// 创建时间：2023/4/14
/// 作者：zxlee
/// 描述：RequestModel

class RequestModel extends Object{
  /// URL
  String url;

  /// briefUrl
  String briefUrl;

  /// Request Method
  String method;

  /// Status Code
  int statusCode;

  /// Request Headers
  Map<String, dynamic> headers;

  /// Data
  dynamic data;

  /// Request Headers
  ResponseModel? response;

  /// Raw Request
  dynamic rawRequest;

  /// timestamp
  int timestamp;

  RequestModel(this.url, this.briefUrl, this.method, this.statusCode, this.headers, this.data, this.response, this.rawRequest, this.timestamp);
}