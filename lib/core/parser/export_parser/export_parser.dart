import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';

abstract class ExportParser {
  String parser(RequestModel requestModel);
}