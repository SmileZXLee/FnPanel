import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fn_panel/fn_panel.dart';

class RequestTestPage extends StatefulWidget {
  const RequestTestPage({Key? key}) : super(key: key);

  @override
  _RequestTestPageState createState() => _RequestTestPageState();
}

class _RequestTestPageState extends State<RequestTestPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _headerController = TextEditingController();
  final _bodyController = TextEditingController();
  final _responseController = TextEditingController();
  final _options = ['GET', 'POST', 'PUT', 'DELETE'];
  String _selectedMethod = 'GET';
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _urlController.text = "https://api.z-notify.zxlee.cn/v1/public/versions/8292724618483712000/1?is_test=1&qa=abc";
    _headerController.text = '{"testHeader": 123}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Test'),
      ),
      body: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(labelText: 'URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _selectedMethod,
                  items: _options.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value.toString();
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _headerController,
                  decoration: InputDecoration(labelText: 'Headers (JSON)'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  decoration: InputDecoration(labelText: 'Body (JSON)'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendRequest,
                  child: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                      : Text('Send Request'),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    controller: _responseController,
                    decoration: InputDecoration(
                        labelText: 'Response',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16.0)),
                    maxLines: null,
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  void _sendRequest() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Dio dio = Dio();
        FnPanel.setDio(dio);
        final response = await dio.request(
          _urlController.text,
          data: _bodyController.text.isNotEmpty ? jsonDecode(_bodyController.text) : null,
          options: Options(
            method: _selectedMethod,
            headers: _headerController.text.isNotEmpty ? jsonDecode(_headerController.text) : null,
          ),
        );
        setState(() {
          _responseController.text = jsonEncode(response.data);
        });
      } catch (e) {
        setState(() {
          _responseController.text = e.toString();
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
