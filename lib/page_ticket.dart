import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';

class pageTicket extends StatefulWidget {
  const pageTicket({Key? key}) : super(key: key);

  @override
  State<pageTicket> createState() => _pageTicketState();
}

class _pageTicketState extends State<pageTicket> {
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
  }

  @override
  void didChangeDependencies() {
    precacheImage(qrImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
          SizedBox(
            width: MediaQuery.of(context).size.width, // 화면 풀 가로 사이즈
            height: 150,
            child: Swiper.children(
              autoplay: false,
              pagination: SwiperPagination(),
              control: SwiperControl(),
              viewportFraction: 0.8,
              scale: 0.9,
              children: swiperItems,
            ),
          ),
        ],
      ),
    );
  }
}
