import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fn_panel/core/parser/request_parser/model/request_model.dart';
import 'package:fn_panel/core/parser/response_parser/model/response_model.dart';
import 'package:fn_panel/core/ui/base/fn_empty_text.dart';
import 'package:fn_panel/core/utils/fn_time_utils.dart';

class FnDetailTiming extends StatefulWidget {
  final RequestModel? requestModel;
  const FnDetailTiming({Key? key, this.requestModel}) : super(key: key);

  @override
  _FnDetailTimingState createState() => _FnDetailTimingState();
}

class _FnDetailTimingState extends State<FnDetailTiming> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequestModel? requestModel = widget.requestModel;
    ResponseModel? responseModel = requestModel?.response;
    return Container(
      padding: const EdgeInsets.all(10),
      child: requestModel != null ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: responseModel != null ? [
            getItem("Request Started", FnTimeUtils.formatTimestamp(requestModel.timestamp)),
            getItem("Request Finished", FnTimeUtils.formatTimestamp(responseModel.timestamp)),
            getItem("Request Duration", FnTimeUtils.formatMilliseconds(responseModel.timestamp - requestModel.timestamp)),
          ] : [
            getItem("Request Started", requestModel.timestamp.toString()),
          ],
        ),
      ) : FnEmptyText(text: "No Timing"),
    );
  }

  Widget getItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.0
            ),
          )
        ],
      ),
    );
  }
}
