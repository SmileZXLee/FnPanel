import 'package:flutter/material.dart';
import '../../utils/fn_print_utils.dart';
import '../../utils/fn_text_utils.dart';

/// FnPanel
///
/// JsonViewer，基于https://github.com/mayankkushal/flutter_json_viewer修改
class FnJsonViewer extends StatefulWidget {
  final dynamic jsonObj;
  const FnJsonViewer(this.jsonObj, {Key? key}) : super(key: key);
  @override
  _FnJsonViewerState createState() => _FnJsonViewerState();
}

class _FnJsonViewerState extends State<FnJsonViewer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 14.0,
      ),
      child: getContentWidget(widget.jsonObj),
    );
  }

  static getContentWidget(dynamic content) {
    if (content == null) {
      return const Text('{}');
    } else if (content is List) {
      return FnJsonArrayViewer(content, notRoot: false);
    } else {
      return FnJsonObjectViewer(content, notRoot: false);
    }
  }
}

class FnJsonObjectViewer extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  const FnJsonObjectViewer(this.jsonObj, {Key? key, this.notRoot = false}) : super(key: key);

  @override
  _FnJsonObjectViewerState createState() => _FnJsonObjectViewerState();
}

class _FnJsonObjectViewerState extends State<FnJsonObjectViewer> {
  Map<String, bool> openFlag = {};

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: _getList()),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  _getList() {
    List<Widget> list = [];
    for (MapEntry entry in widget.jsonObj.entries) {
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: ex
                ? ((openFlag[entry.key] ?? false)
                ? Icon(Icons.arrow_drop_down,
                size: 14, color: Colors.grey[700])
                : Icon(Icons.arrow_right, size: 14, color: Colors.grey[700]))
                : const Icon(
              Icons.arrow_right,
              color: Color.fromARGB(0, 0, 0, 0),
              size: 14,
            ),
            onTap: () {
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key] ?? false);
              });
            },
          ),
          (ex && ink)
              ? InkWell(
                  child: Text(entry.key,
                      style: TextStyle(color: Colors.purple[900])),
                  onTap: () {
                    setState(() {
                      openFlag[entry.key] = !(openFlag[entry.key] ?? false);
                    });
                  })
              : Text(entry.key,
                  style: TextStyle(color: Colors.purple[900])
                ),
          const Text(
            ':',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 3),
          getValueWidget(entry)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[entry.key] ?? false) {
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  static getContentWidget(dynamic content) {
    if (content is List) {
      return FnJsonArrayViewer(content, notRoot: true);
    } else {
      return FnJsonObjectViewer(content, notRoot: true);
    }
  }

  static isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is List) {
      if (content.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  getValueWidget(MapEntry entry) {
    if (entry.value == null) {
      return const Expanded(
          child: Text(
        'null',
        style: TextStyle(color: Colors.grey),
      ));
    } else if (entry.value is int) {
      return Expanded(
          child: SelectableText(
            entry.value.toString(),
            style: const TextStyle(color: Colors.teal),
            onTap: () {
              FnPrintUtils.printMsg("${entry.key}: ${entry.value}");
            },
          )
      );
    } else if (entry.value is String) {
      return Expanded(
          child: SelectableText(
            '"' + entry.value + '"',
            style: const TextStyle(color: Colors.redAccent),
            onTap: () {
              FnPrintUtils.printMsg("${entry.key}: ${entry.value}");
            },
          )
      );
    } else if (entry.value is bool) {
      return Expanded(
          child: Text(
        entry.value.toString(),
        style: const TextStyle(color: Colors.purple),
      ));
    } else if (entry.value is double) {
      return Expanded(
          child: SelectableText(
            entry.value.toString(),
            style: const TextStyle( color: Colors.teal),
            onTap: () {
              FnPrintUtils.printMsg("${entry.key}: ${entry.value}");
            },
          )
      );
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return Expanded(
          child: GestureDetector(
            child: Text(
              'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
            onTap: () {
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key] ?? false);
              });
            }
          )
        );
      }
    }
    return Expanded(
        child: GestureDetector(
          child: Text(
            FnTextUtils.breakWord(entry.value.toString()),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black87
            ),
          ),
          onTap: () {
            setState(() {
              openFlag[entry.key] = !(openFlag[entry.key] ?? false);
            });
          },
        )
    );
  }

  static isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }
    return 'Object';
  }
}

class FnJsonArrayViewer extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  const FnJsonArrayViewer(this.jsonArray, {Key? key, this.notRoot = false}) : super(key: key);

  @override
  _FnJsonArrayViewerState createState() => _FnJsonArrayViewerState();
}

class _FnJsonArrayViewerState extends State<FnJsonArrayViewer> {
  late List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  @override
  void initState() {
    super.initState();
    openFlag = List.filled(widget.jsonArray.length, false);
  }

  _getList() {
    List<Widget> list = [];
    int i = 0;
    for (dynamic content in widget.jsonArray) {
      bool ex = _FnJsonObjectViewerState.isExtensible(content);
      bool ink = _FnJsonObjectViewerState.isInkWell(content);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: getListIcon(ex, i)),
          (ex && ink)
              ? getInkWell(i)
              : Text('[$i]',
                  style: TextStyle(color: content == null ? Colors.grey : Colors.purple[900])
                ),
          const Text(
            ':',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 3),
          getValueWidget(content, i)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[i]) {
        list.add(_FnJsonObjectViewerState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  getInkWell(int index) {
    return InkWell(
        child: Text('[$index]', style: TextStyle(color: Colors.purple[900])
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }

  getListIcon(bool ex, int index) {
    return GestureDetector(
        child: ex
            ? ((openFlag[index])
            ? Icon(Icons.arrow_drop_down,
            size: 14, color: Colors.grey[700])
            : Icon(Icons.arrow_right, size: 14, color: Colors.grey[700]))
            : const Icon(
          Icons.arrow_right,
          color: Color.fromARGB(0, 0, 0, 0),
          size: 14,
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        }
    );
  }

  getValueWidget(dynamic content, int index) {
    if (content == null) {
      return const Expanded(
          child: Text(
        'undefined',
        style: TextStyle(color: Colors.grey),
      ));
    } else if (content is int) {
      return Expanded(
          child: SelectableText(
            content.toString(),
            style: const TextStyle(color: Colors.teal),
            onTap: () {
              FnPrintUtils.printMsg(content.toString());
            },
          )
      );
    } else if (content is String) {
      return Expanded(
          child: SelectableText(
            '"' + content + '"',
            style: const TextStyle(color: Colors.redAccent),
            onTap: () {
              FnPrintUtils.printMsg(content);
            },
          )
      );
    } else if (content is bool) {
      return Expanded(
          child: SelectableText(
            content.toString(),
            style: const TextStyle(color: Colors.purple),
            onTap: () {
              FnPrintUtils.printMsg(content.toString());
            },
          )
      );
    } else if (content is double) {
      return Expanded(
          child: SelectableText(
            content.toString(),
            style: const TextStyle(color: Colors.teal),
              onTap: () {
                FnPrintUtils.printMsg(content.toString());
              },
          )
      );
    } else if (content is List) {
      if (content.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
            child: Text(
              'Array<${_FnJsonObjectViewerState.getTypeName(content)}>[${content.length}]',
              style: const TextStyle(color: Colors.black87),
            ),
            onTap: () {
              setState(() {
                openFlag[index] = !(openFlag[index]);
              });
            });
      }
    }
    return Expanded(
        child: GestureDetector(
          child: Text(
            FnTextUtils.breakWord(content.toString()),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87
            ),
          ),
          onTap: () {
            setState(() {
              openFlag[index] = !(openFlag[index]);
            });
          },
        )
    );
  }
}
