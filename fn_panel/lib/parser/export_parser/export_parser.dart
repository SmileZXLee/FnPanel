import '../request_parser/model/request_model.dart';

/// FnPanel
///
/// 请求导出接口
abstract class ExportParser {
  String parser(RequestModel requestModel);
}