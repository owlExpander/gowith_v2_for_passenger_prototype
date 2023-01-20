import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';

import 'package:gowith_v2_for_passenger_prototype/page_ticket.dart';
import 'package:gowith_v2_for_passenger_prototype/page_route.dart';
import 'package:gowith_v2_for_passenger_prototype/page_gowith.dart';
import 'package:gowith_v2_for_passenger_prototype/page_mypage.dart';
import 'package:gowith_v2_for_passenger_prototype/util_location.dart';

const String appTitle = '동행v2 (승객용) v0.4';

void main() {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
      nativeAppKey: 'b02c980b8d9caf1c7d24ef9547fb4c39',
  );

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

  final List<Widget> _pageList = [
    const pageTicket(),
    const pageRoute(),
    const pageGoWith(),
    const pageMyPage(),
  ];

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    checkCurrentLocation(); // 최초 1회 실행
    Timer.periodic(Duration(seconds: 5), (timer) {  // 일정 시간 간격으로 반복
      checkCurrentLocation();
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
            // 네비게이션 실행 테스트
            IconButton(
                onPressed: () async {
                  //print(await KakaoSdk.origin);

                  if (await NaviApi.instance.isKakaoNaviInstalled()) {
                    // 카카오내비 앱으로 길 안내하기, WGS84 좌표계 사용
                    await NaviApi.instance.navigate(
                      option: NaviOption(
                          coordType: CoordType.wgs84,
                          vehicleType: VehicleType.third,
                      ),
                      destination: Location(name: '어바니엘가산', x: '126.87976185037579', y: '37.4849314292158'),
                      // 경유지 추가
                      viaList: [
                        Location(name: '한화 솔루션큐셀', x: '126.88251119816695', y: '37.476545805363216'),
                        Location(name: '서울 가산디지털 우체국', x: '126.88020295443398', y: '37.47775984994049'),
                        Location(name: '카페 마중물', x: '126.8788983048132', y: '37.48055164721279'),
                        Location(name: '에이스 K1타워', x: '126.87803582657943', y: '37.48253297857724'),
                        Location(name: '리츠빌 아파트', x: '126.87761051212924', y: '37.486812326444735'),
                      ],
                    );
                  } else {
                    //print('카카오내비 미설치');
                    // 카카오내비 설치 페이지로 이동
                    launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
                  }
                },
                icon: const Icon(Icons.navigation_outlined)
            ),
            // QR 버튼
            IconButton(
                visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0), // 아이콘 간격 줄임
                padding: EdgeInsets.zero,                                             // 아이콘 간격 줄임
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
                visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0), // 아이콘 간격 줄임
                padding: EdgeInsets.zero,                                             // 아이콘 간격 줄임
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