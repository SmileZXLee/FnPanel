import 'fn_level_utils.dart';

/// FnPanel
///
/// 打印工具类
class FnPrintUtils {
  static void printMsg(String msg) {
    if (FnLevelUtils.allow()) {
      print(msg);
    }
  }
}