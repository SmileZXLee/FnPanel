# FnPanel

[![Pub](https://img.shields.io/pub/v/fn_panel.svg?style=flat)](https://pub.flutter-io.cn/packages/fn_panel)
[![release](https://img.shields.io/github/v/release/SmileZXLee/FnPanel?style=flat)](https://github.com/SmileZXLee/FnPanel/releases)
[![license](https://img.shields.io/github/license/SmileZXLee/FnPanel?style=flat)](https://en.wikipedia.org/wiki/MIT_License) 

## 主要功能
* 设计参照Chome Network调试面板
* 支持展示请求头、响应头、请求头、响应体、请求时间等
* 支持请求体/响应体格式化展示
* 支持复制请求为cURL或fetch，可直接粘贴至Postman或发给后端调试
* 搭配全局可拖动按钮，可通过全局Button呼出FnPanel面板
* 配置简单，使用方便，侵入性低

## 安装
```yaml
dependencies:
  fn_panel: ^当前最新版本
```

## 使用

导入`fn_panel`
```dart
import 'package:fn_panel/fn_panel.dart';
```

【必须】绑定Dio，请在封装的请求内部绑定
```dart
Dio dio = Dio();
// 对dio的各种配置处理
FnPanel.setDio(dio);
```

【可选】设置全局Button，可通过全局Button呼出FnPanel面板
```dart
FnPanel.setGlobalButton(context);
```

【可选】通过代码呼出FnPanel面板
```dart
FnPanel.showPanel(context);
```

【可选】全局配置
```dart
// 修改全局Button距离bottom 100(默认距离bottom 20，right 20)
FnPanel.setConfig(
  FnConfig(globalButtonConfig: FnGlobalButtonConfig(bottom: 100))
);

// 设置FnPanel在Debug和Release环境下均启用，默认为Level.debug，即只有Debug环境下启用
FnPanel.setConfig(
  FnConfig(level: Level.release)
);
```

## 预览
|                           操作演示                           |                       请求详情-Headers                       |                      请求详情-Response                       |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://zxlee.cn/img/fn-panle-demo1.gif" style="width:300px"/> | <img src="https://zxlee.cn/img/fn-panle-demo2.png" style="width:300px"/> | <img src="https://zxlee.cn/img/fn-panle-demo3.png" style="width:300px"/> |

## 更新历史，请查阅[Release](https://github.com/SmileZXLee/FnPanel/releases)
