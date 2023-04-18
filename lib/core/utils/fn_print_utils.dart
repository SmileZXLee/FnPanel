import 'package:flutter/foundation.dart';

class FnPrintUtils {
  static void printDebug(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}