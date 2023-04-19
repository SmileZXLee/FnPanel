import 'package:dio/dio.dart';
import 'package:fn_panel/fn_panel.dart';

// 详情请访问 https://github.com/SmileZXLee/FnPanel
void main() {
  Dio dio = Dio();
  FnPanel.setDio(dio);
}
