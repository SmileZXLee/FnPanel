import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../utils/fn_time_utils.dart';
import '../model/request_model.dart';
import '../request_parser.dart';

/// FnPanel
///
/// dio Request解析实现
class DioRequestParser implements RequestParser {
  @override
  Future<RequestModel> parser(dynamic request) async{
    RequestOptions dioRequest  = request as RequestOptions;
    String url = dioRequest.path;
    Uri uri = Uri.parse(url);
    String briefUrl = dioRequest.path.isEmpty ? "" : url.substring(url.lastIndexOf('/') + 1);
    String pathWithQuery = dioRequest.path.isEmpty ? "" : url.replaceFirst(uri.origin, "");
    Map<String, dynamic> headers = Map.from(dioRequest.headers);
    if (briefUrl.isEmpty || briefUrl == "/") {
      briefUrl = uri.host;
    }
    if (pathWithQuery.isEmpty || pathWithQuery == "/") {
      pathWithQuery = uri.host;
    }
    dynamic body = dioRequest.data;
    FormDataModel? formDataModel;
    if (body is FormData) {
      FormData newFormData = FormData.fromMap({});
      newFormData.fields.addAll(body.fields);
      if (headers.containsKey("content-type")) {
        headers["content-type"] = headers["content-type"].toString().replaceAll(body.boundary, newFormData.boundary);
      }

      int filesIndex = 0;
      for (MapEntry<String, MultipartFile> originalMap in body.files) {
        MultipartFile originalFile = originalMap.value;
        List<MultipartFile> copiedMultipartFiles = await _copyMultipartFileForTwo(originalFile);
        if (copiedMultipartFiles.length == 2) {
          newFormData.files.add(MapEntry(originalMap.key, copiedMultipartFiles[0]));
          body.files[filesIndex] = MapEntry(originalMap.key, copiedMultipartFiles[1]);
        }
        filesIndex ++;
      }

      String formDataAsString = "";
      try {
        formDataAsString = await newFormData.finalize().transform(utf8.decoder).join();
      } catch (_) {}
      formDataModel = FormDataModel(
        newFormData.fields.map((entry) => { entry.key: entry.value }).toList(),
        List.of(body.files),
        newFormData.boundary,
        formDataAsString
      );
      body = null;
    }

    RequestModel requestModel = RequestModel(
      url,
      pathWithQuery,
      briefUrl,
      dioRequest.method,
      -1,
      headers,
      body,
      formDataModel,
      null,
      dioRequest,
      FnTimeUtils.getTimestamp()
    );
    return requestModel;
  }

  Future<List<MultipartFile>> _copyMultipartFileForTwo(MultipartFile original) async {
    final Stream<List<int>> stream = original.finalize();
    final List<int> data = await stream.toList().then((chunks) {
      final bytes = <int>[];
      for (final chunk in chunks) {
        bytes.addAll(chunk);
      }
      return bytes;
    });

    final newFile1 = MultipartFile.fromBytes(
      data,
      filename: original.filename,
      contentType: original.contentType,
      headers: original.headers
    );

    final newFile2 = MultipartFile.fromBytes(
        data,
        filename: original.filename,
        contentType: original.contentType,
        headers: original.headers
    );

    return [newFile1, newFile2];
  }
}