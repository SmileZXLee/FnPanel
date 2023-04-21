import 'model/request_model.dart';

/// FnPanel
///
/// Request解析接口
abstract class RequestParser {
  Future<RequestModel> parser(dynamic request);
}