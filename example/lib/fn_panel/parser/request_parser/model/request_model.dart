import 'package:dio/dio.dart';

import '../../response_parser/model/response_model.dart';

/// FnPanel
///
/// FormData包装类
class FormDataModel extends Object {
  List<Map<String, String>> fields;
  List<MapEntry<String, MultipartFile>> files;
  String boundary;
  String asString;

  FormDataModel(this.fields, this.files, this.boundary, this.asString);
}

/// FnPanel
///
/// Request包装类
class RequestModel extends Object{
  /// URL
  String url;

  /// path + query
  String pathWithQuery;

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

  /// FromData
  FormDataModel? fromData;

  /// Request Headers
  ResponseModel? response;

  /// Raw Request
  dynamic rawRequest;

  /// timestamp
  int timestamp;

  RequestModel(this.url, this.pathWithQuery, this.briefUrl, this.method, this.statusCode, this.headers, this.data, this.fromData, this.response, this.rawRequest, this.timestamp);
}