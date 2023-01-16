import 'package:flutter/cupertino.dart';

class pageMyPage extends StatefulWidget {
  const pageMyPage({Key? key}) : super(key: key);

  @override
  State<pageMyPage> createState() => _pageMyPageState();
}

class _pageMyPageState extends State<pageMyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('마이페이지'),
    );
  }
}
