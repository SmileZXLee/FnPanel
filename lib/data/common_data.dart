import 'dart:ui';

import '/parser/request_parser/model/request_model.dart';
import '../config/fn_config.dart';

/// FnPanel
///
/// 全局通用数据
class CommonData {
  /// 全局配置
  static FnConfig? config;

  /// 请求/响应更新回调
  static Function? requestUpdateCallback;

  /// Request List
  static List<RequestModel> requestList = [];

  /// 未响应的请求Map，key为请求的唯一标识，value为此请求在requestList中的index
  static Map<int, int> requestingMap = {};

  /// 全局请求按钮offset
  static Offset? globalButtonOffset;
}