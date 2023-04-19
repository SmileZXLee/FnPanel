import 'package:flutter/foundation.dart';
import 'package:fn_panel/core/utils/fn_level_utils.dart';


/// FnPanel
///
/// 打印工具类
class FnPrintUtils {
  static void print(String msg) {
    if (FnLevelUtils.allow()) {
      print(msg);
    }
  }
}