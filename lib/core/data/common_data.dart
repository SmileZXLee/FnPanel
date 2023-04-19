import 'dart:ui';

import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';

class CommonData {
  static List<RequestModel> requestList = [];

  static Map<int, int> requestingMap = {};

  static Offset? globalButtonOffset = null;
}