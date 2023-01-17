import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:gowith_v2_for_passenger_prototype/util_location.dart';

/*
Flutter 앱에 WebView 추가 (https://codelabs.developers.google.com/codelabs/flutter-webview)
패키지는 현재 webview_flutter 최신 버전과 위 강좌 내용이 맞지 않아 3.0대 버전으로 사용
(https://pub.dev/packages/webview_flutter/versions/3.0.4)
*/

class pageRoute extends StatefulWidget {
  const pageRoute({Key? key}) : super(key: key);

  @override
  State<pageRoute> createState() => _pageRouteState();
}

class _pageRouteState extends State<pageRoute> {
  var loadingPercentage = 0;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController _myController;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: 'https://www.mtis21.com/jhpark/route.html',
          onWebViewCreated: (webViewController) {
            _myController = webViewController;
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,  // 웹뷰내 페이지 Javascript 동작하게..
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;

              // 페이지 로드가 다 끝나면 현재 위도 경도 전달
              checkCurrentLocation();
              _myController.runJavascript('fn_setLatLng($lat, $lng);');
            });
          },
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}