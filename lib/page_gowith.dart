import 'package:flutter/cupertino.dart';

class pageGoWith extends StatefulWidget {
  const pageGoWith({Key? key}) : super(key: key);

  @override
  State<pageGoWith> createState() => _pageGoWithState();
}

class _pageGoWithState extends State<pageGoWith> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('동행 승하차'),
    );
  }
}
