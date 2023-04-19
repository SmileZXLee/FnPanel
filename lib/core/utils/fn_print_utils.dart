import 'package:flutter/foundation.dart';

/// FnPanel
///
/// 打印工具类
class FnPrintUtils {
  static void printDebug(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}