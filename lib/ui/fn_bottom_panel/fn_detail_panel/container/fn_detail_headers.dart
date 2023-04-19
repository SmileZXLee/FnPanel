import 'package:flutter/material.dart';
import '/parser/request_parser/model/request_model.dart';
import '/parser/response_parser/model/response_model.dart';
import '/ui/base/fn_custom_expansion_tile.dart';
import '/utils/fn_print_utils.dart';
import '/utils/fn_text_utils.dart';

/// FnPanel
///
/// FnPanel左侧请求详情-Headers
class FnDetailHeaders extends StatefulWidget {
  final RequestModel? requestModel;
  const FnDetailHeaders({Key? key, this.requestModel}) : super(key: key);

  @override
  _FnDetailHeadersState createState() => _FnDetailHeadersState();
}

class _FnDetailHeadersState extends State<FnDetailHeaders> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child:  ListView(
          children: getHeaderWidgets(),
        ),
      ),
    );
  }

  List<Widget> getHeaderWidgets() {
    List<Map<String, String>> generalHeaders = _getGeneralHeaders();
    List<Map<String, String>> requestHeaders = _getRequestHeaders();
    List<Map<String, String>> responseHeaders = _getResponseHeaders();
    List<Widget> headerWidgets = [];
    if (generalHeaders.isNotEmpty) {
      headerWidgets.add(_buildHeader('General', generalHeaders));
    }
    if (requestHeaders.isNotEmpty) {
      headerWidgets.add(_buildHeader('Request Headers', requestHeaders));
    }
    if (responseHeaders.isNotEmpty) {
      headerWidgets.add(_buildHeader('Response Headers', responseHeaders));
    }
    return headerWidgets;
  }

  List<Map<String, String>> _getGeneralHeaders() {
    RequestModel? requestModel = widget.requestModel;
    ResponseModel? responseModel = requestModel?.response;
    List<Map<String, String>> commonHeaders = [
      {"title": "Request URL", "desc": FnTextUtils.breakWord((requestModel?.url).toString())},
      {"title": "Request Method", "desc": (requestModel?.method).toString()}
    ];
    if (responseModel != null) {
      commonHeaders.add({"title": "Status Code", "desc": responseModel.statusCode.toString()});
    }
    return commonHeaders;
  }

  List<Map<String, String>> _getRequestHeaders() {
    RequestModel? requestModel = widget.requestModel;
    Map<String, dynamic>? headers = requestModel?.headers;
    if (headers != null) {
      return headers.entries.map((entry) {
        final key = entry.key;
        final value = entry.value.toString();
        return {"title": key, "desc": value};
      }).toList();
    }
    return [];
  }

  List<Map<String, String>> _getResponseHeaders() {
    ResponseModel? responseModel = widget.requestModel?.response;
    Map<String, dynamic>? headers = responseModel?.headers;
    if (headers != null) {
      return headers.entries.map((entry) {
        final key = entry.key;
        final value = entry.value is List ? (entry.value as List).join(",") : entry.value.toString();
        return {"title": key, "desc": value};
      }).toList();
    }
    return [];
  }

  Widget _buildHeader(String title, List<Map<String, String>> headers) {
    return FnCustomExpansionTitle(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold
        ),
      ),
      children: [
        Column(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: headers.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, String> header = headers[index];
                  return Container(
                    padding: EdgeInsets.only(left: 15, bottom: 5),
                    child: SelectableText.rich(
                      TextSpan(
                        text: '${header['title']}: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                        children: [
                          TextSpan(
                            text: '${header['desc']}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: _getDescColor(header['title'].toString(), header['desc'].toString()),
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        FnPrintUtils.print("${header['title']}: ${header['desc']}");
                      },
                    ),
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Color _getDescColor(String title, String desc) {
    if (title == "Status Code") {
      if (RegExp(r'^[13]').hasMatch(desc)) {
        return Colors.black38;
      } else if (desc.startsWith("2")) {
        return Colors.green;
      } else if (RegExp(r'^[45]').hasMatch(desc)) {
        return Colors.red;
      }
    }
    return Colors.black87;
  }
}


