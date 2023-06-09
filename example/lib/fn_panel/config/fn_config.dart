
import 'dart:ui';

enum Level {
  debug,
  release,
}

/// FnPanel
///
/// FnPanel通用配置
class FnConfig {
  FnGlobalButtonConfig? globalButtonConfig;

  Level? level;

  FnConfig({this.globalButtonConfig, this.level});
}

class FnGlobalButtonConfig {
  /// 全局按钮与屏幕底部距离
  double? bottom;

  /// 全局按钮与屏幕右侧距离
  double? right;

  /// 全局按钮颜色
  Color? color;

  FnGlobalButtonConfig({this.bottom, this.right, this.color});
}