import 'package:flutter/material.dart';
import '../quiz_pages/aQuizPage.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/StoreQuizsTodate.dart';

//量表结果的历史记录
class vasIntroPage extends StatefulWidget {
  // String data;
  const vasIntroPage({super.key}); //, required this.data

  @override
  State<vasIntroPage> createState() => _vasIntroPageState();
}

class _vasIntroPageState extends State<vasIntroPage> {
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
          '视觉模拟量表（VAS）',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18 * MediaQSize.heightRefScale,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(IconData(0xe903, fontFamily: 'Path4icons'),
              color: Colors.black),
          tooltip: "回到量表主页",
          iconSize: 20 * MediaQSize.widthRefScale,
          onPressed: () {
            Navigator.pop(context);
          },
        ), //如果写了leading就不会有默认的返回键了
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
      ),
      body: Container(
        height: MediaQSize.thisDsize.height,
        width: MediaQSize.thisDsize.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/VASintro.png"),
                fit: BoxFit.cover)),
        child: ListView(
          children: [
            Container(
              width: 99.2 * 7 * MediaQSize.widthRefScale,
              height: 8.8 * 7 * MediaQSize.widthRefScale,
              margin: const EdgeInsets.fromLTRB(30, 400, 30, 0) *
                  MediaQSize.widthRefScale,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizPage(
                          chosenquiz: StoreQuizs.quizsList[1]))); //传入加载的THI量表
                },
                child: const Image(
                    image: AssetImage("assets/images/startans.png"),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
