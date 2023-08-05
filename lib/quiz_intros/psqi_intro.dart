import 'package:flutter/material.dart';
import '../quiz_pages/aQuizPage.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/StoreQuizsTodate.dart';

//量表结果的历史记录
class PSQIIntroPage extends StatefulWidget {
  // String data;
  const PSQIIntroPage({super.key}); //, required this.data

  @override
  State<PSQIIntroPage> createState() => _PSQIIntroPageState();
}

class _PSQIIntroPageState extends State<PSQIIntroPage> {
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
          '匹兹堡睡眠质量指数量表（PSQI）',
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
                image: AssetImage("assets/images/PSQIintro.png"),
                fit: BoxFit.cover)), //背景图
        child: ListView(
          children: [
            Container(
              width: 99.2 * 7 * MediaQSize.widthRefScale,
              height: 8.8 * 7 * MediaQSize.widthRefScale,
              margin: const EdgeInsets.fromLTRB(30, 400, 30, 0) *
                  MediaQSize.widthRefScale,
              child: TextButton(
                child: const Image(
                    image: AssetImage("assets/images/startans.png"), //“开始答题”图标
                    fit: BoxFit.fill),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizPage(
                          chosenquiz:
                              StoreQuizs.quizsList[4]))); //加载入PSQI量表,后面可被返回
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
