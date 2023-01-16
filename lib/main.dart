import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gowith_v2_for_passenger_prototype/page_gowith.dart';
import 'package:gowith_v2_for_passenger_prototype/page_mypage.dart';
import 'package:gowith_v2_for_passenger_prototype/page_route.dart';
import 'package:location/location.dart';

import 'package:gowith_v2_for_passenger_prototype/page_ticket.dart';


const String appTitle = '동행v2 (승객용) v0.2';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  late double? lat;
  late double? lng;
  int nCheckCnt = 0;
  late String strLat = '';
  late String strLng = '';
  Location location = Location();

  List<Widget> _pageList = [
    pageTicket(),
    pageRoute(),
    pageGoWith(),
    pageMyPage(),
  ];

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _locateMe(); // 최초 1회 실행
    Timer.periodic(Duration(seconds: 5), (timer) {  // 일정 시간 간격으로 반복
      _locateMe();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(appTitle),
        actions: [
          // QR 버튼
          IconButton(
              onPressed: () {
                showDialog<void>(context: context, builder: (context) => _showAlertDialog('알림', '준비중 입니다.'));
              },
              icon: const Icon(Icons.qr_code)
          ),
          // 알림 버튼
          IconButton(
              onPressed: () {
                showDialog<void>(context: context, builder: (context) => _showAlertDialog('알림', '준비중 입니다.'));
              },
              icon: const Icon(Icons.notifications)
          ),
          // 메뉴 버튼
          IconButton(
              onPressed: _openEndDrawer,
              icon: const Icon(Icons.menu)
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(nCheckCnt > 0 ? '$nCheckCnt | $lat | $lng' : ''),
        ),
      ),
      endDrawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is the Drawer'),
              ElevatedButton(
                onPressed: _closeEndDrawer,
                child: const Text('Close Drawer'),
              ),
            ],
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: _pageList[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,	// item이 4개 이상일 경우 추가
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: '탑승권'),
          BottomNavigationBarItem(icon: Icon(Icons.assistant_navigation), label: '노선 검색'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: '동행 승하차'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
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
        }
      });
    });
  }

  _showAlertDialog(String titie, String content) {
    return AlertDialog(
      title: Text(titie),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}