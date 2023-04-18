
class FnTimeUtils {
  static int getTimestamp() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  static String formatTimestamp(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}.${date.millisecond.toString().padLeft(3, '0')}';
    return formattedDate;
  }

  static String formatMilliseconds(int milliseconds) {
    if (milliseconds < 1000) {
      return '$milliseconds ms';
    } else {
      double seconds = milliseconds / 1000;
      return '${seconds.toStringAsFixed(1)} s';
    }
  }
}