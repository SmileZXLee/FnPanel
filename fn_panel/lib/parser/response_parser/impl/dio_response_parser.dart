import 'package:dio/dio.dart';
import '../model/response_model.dart';
import '../response_parser.dart';
import '../../../utils/fn_time_utils.dart';



/// FnPanel
///
/// dio Response解析实现
class DioResponseParser implements ResponseParser {
  @override
  Future<ResponseModel> parser(dynamic response) {
    Response dioResponse  = response as Response;
    ResponseModel responseModel = ResponseModel(
        dioResponse.realUri.toString(),
        dioResponse.statusCode,
        dioResponse.statusMessage,
        dioResponse.headers.map,
        dioResponse.data,
        FnTimeUtils.getTimestamp()
    );
    return Future.value(responseModel);
  }

}