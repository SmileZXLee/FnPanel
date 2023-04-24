
/// FnPanel
///
/// Response包装类
class ResponseModel extends Object{
  /// URL
  String url;

  /// Status Code
  int? statusCode;

  /// Status Message
  String? statusMessage;

  /// Response Headers
  Map<String, dynamic> headers;

  /// Response Data
  dynamic data;

  /// timestamp
  int timestamp;

  ResponseModel(this.url, this.statusCode, this.statusMessage, this.headers, this.data, this.timestamp);
}