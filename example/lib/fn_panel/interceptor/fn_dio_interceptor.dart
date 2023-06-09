import 'package:dio/dio.dart';

import '../data/common_data.dart';
import '../parser/request_parser/impl/dio_request_parser.dart';
import '../parser/request_parser/model/request_model.dart';
import '../parser/response_parser/impl/dio_response_parser.dart';
import '../parser/response_parser/model/response_model.dart';

/// FnPanel
///
/// Dio拦截器
class FnDioInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    CommonData.requestingMap[options.hashCode] = CommonData.requestList.length;
    DioRequestParser().parser(options).then((RequestModel requestModel) {
      CommonData.requestList.add(requestModel);
      _updateRequest();
      super.onRequest(options, handler);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    DioResponseParser().parser(response).then((ResponseModel responseModel) {
      int? requestIndex = CommonData.requestingMap[response.requestOptions.hashCode];
      if (requestIndex != null) {
        CommonData.requestList[requestIndex].response = responseModel;
        CommonData.requestingMap.remove(response.requestOptions.hashCode);
      }
      _updateRequest();
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response != null) {
      DioResponseParser().parser(err.response).then((ResponseModel responseModel) {
        int? requestIndex = CommonData.requestingMap[err.requestOptions.hashCode];
        if (requestIndex != null) {
          CommonData.requestList[requestIndex].response = responseModel;
          CommonData.requestingMap.remove(err.requestOptions.hashCode);
        }
        _updateRequest();
      });
    }
  }

  void _updateRequest() {
    if (CommonData.requestUpdateCallback != null) {
      CommonData.requestUpdateCallback!();
    }
  }
}