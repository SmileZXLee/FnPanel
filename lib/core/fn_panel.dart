import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fn_panel/core/interceptor/fn_dio_interceptor.dart';
import 'package:fn_panel/core/ui/config/fn_config.dart';
import 'package:fn_panel/core/ui/fn_bottom_panel/fn_bottom_panel.dart';

import 'data/common_data.dart';

class FnPanel {

  /// 设置网络请求dio
  ///
  /// di0
  /// Returns void
  static void setDio(Dio dio) {
    dio.interceptors.add(FnDioInterceptor());
  }

  /// 设置通用配置
  ///
  /// config
  /// Returns void
  static void setConfig(FnConfig config) {
    CommonData.config = config;
  }

  /// 添加全局按钮
  ///
  /// context
  /// Returns void
  static void setGlobalButton(BuildContext context) {
    FnBottomPanel.addGlobalButton(context);
  }

  /// 移除全局按钮
  ///
  ///
  /// Returns void
  static void removeGlobalButton() {
    FnBottomPanel.removeGlobalButton();
  }

  /// 显示FnPanel
  ///
  /// context
  /// Returns void
  static void showPanel(BuildContext context) {
    FnBottomPanel.show(context);
  }

  /// 关闭FnPanel
  ///
  /// context
  /// Returns void
  static void dismissPanel(BuildContext context) {
    FnBottomPanel.dismiss();
  }

}
