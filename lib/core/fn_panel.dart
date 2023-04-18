import 'package:dio/dio.dart';
import 'package:fn_panel/core/parser/request_parser/impl/dio_request_parser.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/parser/request_parser/request_parser.dart';
import 'package:fn_panel/core/parser/response_parser/impl/dio_response_parser.dart';
import 'package:fn_panel/core/parser/response_parser/model/response_model.dart';
import 'package:fn_panel/core/parser/response_parser/response_parser.dart';

import 'data/common_data.dart';

class FnPanel {

  static Function? requestUpdateCallback;

  static void initWithDio(Dio dio) {
    dio.interceptors
        .add(_FnDioInterceptors());
  }
}

class _FnDioInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    CommonData.requestingMap[options.hashCode] = CommonData.requestList.length;
    RequestParser requestParser = DioRequestParser();
    RequestModel requestModel = requestParser.parser(options);
    CommonData.requestList.add(requestModel);

    if (FnPanel.requestUpdateCallback != null) {
      FnPanel.requestUpdateCallback!();
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ResponseParser responseParser = DioResponseParser();
    ResponseModel responseModel = responseParser.parser(response);
    int? requestIndex = CommonData.requestingMap[response.requestOptions.hashCode];
    if (requestIndex != null) {
      CommonData.requestList[requestIndex].response = responseModel;
      CommonData.requestingMap.remove(response.requestOptions.hashCode);
    }

    if (FnPanel.requestUpdateCallback != null) {
      FnPanel.requestUpdateCallback!();
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}