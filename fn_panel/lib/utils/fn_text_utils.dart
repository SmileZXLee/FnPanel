
/// FnPanel
///
/// Text工具类
class FnTextUtils {
  /// 使文字在任意位置换行
  static String breakWord(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.replaceAll("", "\u200B");
  }

  /// 移除\u200B
  static String removeU200B(String text) {
    return text.replaceAll("\u200B", "");
  }
}