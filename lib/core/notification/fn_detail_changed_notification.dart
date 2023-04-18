import 'package:flutter/cupertino.dart';
import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';

class FnDetailChangedNotification extends Notification {
  final RequestModel requestModel;
  FnDetailChangedNotification(this.requestModel);
}