import 'package:fn_panel/core/parser/response_parser/model/response_model.dart';

/// FnPanel
///
/// Request包装类
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