import 'model/request_model.dart';

abstract class RequestParser {
  RequestModel parser(dynamic request);
}