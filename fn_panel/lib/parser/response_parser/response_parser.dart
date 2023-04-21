import './model/response_model.dart';

/// FnPanel
///
/// Response解析接口
abstract class ResponseParser {
  ResponseModel parser(dynamic response);
}