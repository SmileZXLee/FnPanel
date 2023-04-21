import 'package:flutter/foundation.dart';

import '../config/fn_config.dart';
import '../data/common_data.dart';

/// FnPanel
///
/// 当前环境Level工具类
class FnLevelUtils {
  static bool allow() {
    Level level = CommonData.config?.level ?? Level.debug;
    if (level == Level.debug) {
      return kDebugMode || kProfileMode;
    } else if (level == Level.release) {
      return kDebugMode || kReleaseMode || kProfileMode;
    }
    return false;
  }
}