import 'package:fn_panel/core/utils/fn_time_utils.dart';

import '../model/response_model.dart';

import '../response_parser.dart';
import 'package:dio/dio.dart';

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