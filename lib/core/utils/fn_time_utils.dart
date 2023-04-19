
/// FnPanel
///
/// 时间工具类
class FnTimeUtils {
  /// 获取当前时间戳
  static int getTimestamp() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  /// 格式化时间戳为yyyy-MM-dd HH:mm:ss.sss格式
  static String formatTimestamp(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}.${date.millisecond.toString().padLeft(3, '0')}';
    return formattedDate;
  }

  /// 格式化毫秒为ms或s
  static String formatMilliseconds(int milliseconds) {
    if (milliseconds < 1000) {
      return '$milliseconds ms';
    } else {
      double seconds = milliseconds / 1000;
      return '${seconds.toStringAsFixed(1)} s';
    }
  }
}