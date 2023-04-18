import 'model/response_model.dart';

abstract class ResponseParser {
  ResponseModel parser(dynamic response);
}