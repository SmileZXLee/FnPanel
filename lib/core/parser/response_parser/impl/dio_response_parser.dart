import 'package:dio/dio.dart';
import 'package:fn_panel/core/parser/response_parser/model/response_model.dart';
import 'package:fn_panel/core/parser/response_parser/response_parser.dart';
import 'package:fn_panel/core/utils/fn_time_utils.dart';



/// FnPanel
///
/// dio Response解析实现
class DioResponseParser implements ResponseParser {
  @override
  ResponseModel parser(dynamic response) {
    Response dioResponse  = response as Response;
    ResponseModel responseModel = ResponseModel(
        dioResponse.realUri.toString(),
        dioResponse.statusCode,
        dioResponse.statusMessage,
        dioResponse.headers.map,
        dioResponse.data,
        FnTimeUtils.getTimestamp()
    );
    return responseModel;
  }

}