import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';
import '../configs/media_QSize.dart';

//量表结果的历史记录
class QrDisplayPage extends StatefulWidget {
  // String data;
  const QrDisplayPage({super.key}); //, required this.data

  @override
  State<QrDisplayPage> createState() => _QrDisplayPageState();
}

class _QrDisplayPageState extends State<QrDisplayPage> {
  @override
  Widget build(BuildContext context) {
    // //调用函数 获取设备尺寸信息和缩放比
    // MediaQSize().initMQ(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,
        title: Text(
          '生成二维码',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18 * MediaQSize.heightRefScale,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度

        // leading: IconButton( icon: const Icon(IconData(0xe903, fontFamily: 'Path4icons'),color: Colors.black),
        //   tooltip: "回到量表主页",iconSize: 20,onPressed: () {Navigator.pop(context); //返回不再是二维码
        //   }, ), //如果写了leading就不会有默认的返回键了
      ),
      body: Container(
        height: MediaQSize.thisDsize.height,
        width: MediaQSize.thisDsize.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover)), //背景图
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //纵向居中
            children: [
              Text("请用设备扫描读取：",
                  style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale)),
              SizedBox(
                height: 20 * MediaQSize.heightRefScale,
              ),
              QrImage(
                data: StoreQuizs.strdata,
                size: 300 * MediaQSize.heightRefScale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
