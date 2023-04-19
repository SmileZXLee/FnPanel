# FnPanel

## 主要功能
* 设计参照Chome Network调试面板
* 支持展示请求头、响应头、请求头、响应体、请求时间等
* 支持请求体/响应体格式化展示
* 支持复制请求为cURL，可直接粘贴至postman或发给后端调试
* 搭配全局可拖动按钮，可通过全局Button呼出FnPanel面板
* 配置简单，使用方便，侵入性低

## 安装
TODO

## 使用
【必须】绑定Dio，请在封装的请求内部绑定
```dart
Dio dio = Dio();
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

## 预览
|                           操作演示                           |                       请求详情-Headers                       |                      请求详情-Response                       |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://zxlee.cn/img/fn-panle-demo1.gif" style="width:300px"/> | <img src="https://zxlee.cn/img/fn-panle-demo2.png" style="width:300px"/> | <img src="https://zxlee.cn/img/fn-panle-demo3.png" style="width:300px"/> |







