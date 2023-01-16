import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gowith_v2_for_passenger_prototype/page_gowith.dart';
import 'package:gowith_v2_for_passenger_prototype/page_mypage.dart';
import 'package:gowith_v2_for_passenger_prototype/page_route.dart';
import 'package:location/location.dart';

import 'package:gowith_v2_for_passenger_prototype/page_ticket.dart';


const String appTitle = '동행v2 (승객용) v0.4';

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
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(appTitle),
          actions: [
            // QR 버튼
            IconButton(
                onPressed: () {
                  showDialog<void>(context: context, builder: (context) => _showAlertDialog('준비중 입니다.'));
                },
                icon: const Icon(Icons.qr_code_scanner)
            ),
            // 알림 버튼
            IconButton(
                visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0), // 아이콘 간격 줄임
                padding: EdgeInsets.zero,                                             // 아이콘 간격 줄임
                onPressed: () {
                  showDialog<void>(context: context, builder: (context) => _showAlertDialog('준비중 입니다.'));
                },
                icon: const Icon(Icons.notifications_none)
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
        endDrawer: getEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: _pageList[_currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,	// item이 4개 이상일 경우 추가
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: '탑승권'),
            BottomNavigationBarItem(icon: Icon(Icons.near_me_outlined), label: '노선 검색'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: '동행 승하차'),
            BottomNavigationBarItem(icon: Icon(Icons.sentiment_satisfied_alt), label: '마이페이지'),
          ],
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
      ),
    );
  }

  // 메뉴 영역
  Widget getEndDrawer() {
    /*return Container(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );*/
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 자동으로 생기는 백버튼 제거
        titleSpacing: 0.0,
        title: Row(
          children: [
            // QR 버튼
            IconButton(
                onPressed: () {
                  showDialog<void>(context: context, builder: (context) => _showAlertDialog('준비중 입니다.'));
                },
                icon: const Icon(Icons.qr_code)
            ),
            // 알림 버튼
            IconButton(
                onPressed: () {
                  showDialog<void>(context: context, builder: (context) => _showAlertDialog('준비중 입니다.'));
                },
                icon: const Icon(Icons.notifications)
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
          ),
        ],
      ),
      body: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.confirmation_number_outlined),
            title: Text('탑승권'),
            onTap: () {
              setState(() {
                _currentPageIndex = 0;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.near_me_outlined),
            title: Text('노선검색'),
            onTap: () {
              setState(() {
                _currentPageIndex = 1;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory_2_outlined),
            title: Text('동행 승하차'),
            onTap: () {
              setState(() {
                _currentPageIndex = 2;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.sentiment_satisfied_alt),
            title: Text('마이페이지'),
            onTap: () {
              setState(() {
                _currentPageIndex = 3;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_active_outlined),
            title: Text('푸시알림'),
            onTap: () {
              showDialog<void>(context: context, builder: (context) => _showAlertDialog('준비중 입니다.'));
            },
          ),
        ],
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

  _showAlertDialog(String content, [String? titie]) {
    return AlertDialog(
      title: Text(titie ?? '알림'),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  _showSnackBar(String content) {
    final snackBar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: '닫기',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}