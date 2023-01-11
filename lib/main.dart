import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

const String appTitle = '동행 v2 (승객용) 프로토타입 v0.2';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double? lat;
  late double? lng;
  int nCheckCnt = 0;
  late String strLat = '';
  late String strLng = '';
  Location location = Location();

  late Image qrImage;
  int qrWidth  = 250;
  int qrHeight = 250;

  List<Widget> swiperItems = [];

  @override
  void initState() {
    super.initState();

    // QR 이미지 미리 생성.. 하고 싶은데 잘 안된다 ㅠ
    const String qrResult = "SUCCESS";
    String qrSrc = 'https://chart.googleapis.com/chart?cht=qr&chld=L|0&chs=${qrWidth}x${qrHeight}&chl=$qrResult';
    qrImage = Image.network(qrSrc);

    int itemWidth = 300;
    swiperItems.add(SizedBox(width: itemWidth.toDouble(), height: 150, child: Image.network("https://placeimg.com/${itemWidth}/150", fit: BoxFit.contain,),));
    swiperItems.add(SizedBox(width: itemWidth.toDouble(), height: 150, child: Image.network("https://placeimg.com/${itemWidth}/150?1", fit: BoxFit.contain,),));
    swiperItems.add(SizedBox(width: itemWidth.toDouble(), height: 150, child: Image.network("https://placeimg.com/${itemWidth}/150?2", fit: BoxFit.contain,),));

    _locateMe(); // 최초 1회 실행
    Timer.periodic(Duration(seconds: 5), (timer) {  // 일정 시간 간격으로 반복
      _locateMe();
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(qrImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50,),
            SizedBox(
              width: qrWidth.toDouble(),
              height: qrHeight.toDouble(),
              child: qrImage,
            ),

            const SizedBox(height: 50,),
            Text('$nCheckCnt회 위치 조회'),
            Text(strLat),
            Text(strLng),

            const SizedBox(height: 50,),
            SizedBox(
              width: MediaQuery.of(context).size.width, // 화면 풀 가로 사이즈
              height: 150,
              child: Swiper.children(
                autoplay: false,
                pagination: SwiperPagination(),
                control: SwiperControl(),
                children: swiperItems,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }

    /// 현재 위치 조회
  _locateMe() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) {
      setState(() {
        lat = res.latitude;
        lng = res.longitude;

        if (lat != null) {
          nCheckCnt++;
          strLat = '현재 위도 : $lat';
          strLng = '현재 경도 : $lng';
        }
      });
    });
  }
}