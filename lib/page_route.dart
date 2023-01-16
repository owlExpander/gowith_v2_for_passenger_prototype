import 'package:flutter/cupertino.dart';

class pageRoute extends StatefulWidget {
  const pageRoute({Key? key}) : super(key: key);

  @override
  State<pageRoute> createState() => _pageRouteState();
}

class _pageRouteState extends State<pageRoute> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('노선 검색'),
    );
  }
}
