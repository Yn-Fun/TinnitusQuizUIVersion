//以下为文件6-qrDisplayPage.dart中的内容：

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';
import '../configs/media_QSize.dart';

//量表结果的历史记录
class qrDisplayPage extends StatefulWidget {
  // String data;
  const qrDisplayPage({super.key}); //, required this.data

  @override
  State<qrDisplayPage> createState() => _qrDisplayPageState();
}

class _qrDisplayPageState extends State<qrDisplayPage> {
  @override
  Widget build(BuildContext context) {
    // //调用函数 获取设备尺寸信息和缩放比
    // MediaQSize().initMQ(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,
        title: Text(
          '二维码生成',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.home),
        //   tooltip: "回到量表主页",
        //   iconSize: 30,
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, "/start"); //返回不再是二维码
        //   },
        // ),//如果写了leading就不会有默认的返回键了
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度

        // title: SizedBox(
        //   width: 600 * MediaQSize.widthRefScale, //足够大=父容器的大小
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 60 * MediaQSize.heightRefScale),
        //     child:
        //   ),
        // ),
        //二维码界面右上角的两个键也不用了
        // actions: [
        //   Row(
        //     children: [
        //       // ElevatedButton(
        //       //   style: ElevatedButton.styleFrom(
        //       //       // disabledBackgroundColor: AppColors.lightgray,
        //       //       // foregroundColor: Theme.of(context).colorScheme.secondary,
        //       //       backgroundColor: AppColors.blue1),
        //       //   child: Column(children: const [
        //       //     Icon(
        //       //       Icons.refresh,
        //       //       size: 30,
        //       //     ),
        //       //     Text("刷新"),
        //       //   ]),
        //       //   onPressed: () {
        //       //     Navigator.pushNamed(context, "/qrDisplay");
        //       //   },
        //       // ),

        //       // TextButton.icon(
        //       //   // style: TextButton.styleFrom(backgroundColor: AppColors.blue1),
        //       //   icon: const Icon(
        //       //     Icons.refresh,
        //       //     size: 35,
        //       //     color: Colors.white,
        //       //   ),
        //       //   label: const Text("刷新", style: TextStyle(color: Colors.white)),
        //       //   onPressed: () {
        //       //     Navigator.pushNamed(context, "/qrDisplay");
        //       //   },
        //       // ),

        //       IconButton(
        //         icon: const Icon(Icons.home),
        //         tooltip: "回到量表主页",
        //         iconSize: 30 * MediaQSize.heightRefScale,
        //         onPressed: () {
        //           Navigator.pushNamedAndRemoveUntil(context, "/",
        //               ModalRoute.withName('/quizSelction')); //堆栈只剩下主页 且显示的是第一分页
        //           // Navigator.popUntil(
        //           //     context, ModalRoute.withName("/")); //改为popuntil回到量表首页（需有出现过）很难调节
        //         },
        //       ),
        //       IconButton(
        //         tooltip: "量表本地历史记录",
        //         icon: const Icon(Icons.history_sharp),
        //         iconSize: 30 * MediaQSize.heightRefScale,
        //         onPressed: () {
        //           // Navigator.pushNamed(context, "/quizhistory");//bug是由二维码界面进入历史记录界面后，如果按返回，会仍保留了删除前的码界面
        //           Navigator.pushReplacementNamed(context,
        //               "/quizhistory"); //更改为直接替代，直接返回结果界面，而不是二维码界面，免得上述问题
        //         },
        //       ),
        //     ],
        //   )
        // ],
      ),
      //暂时不用了
      // floatingActionButton: Container(
      //     height: 80, //调整FloatingActionButton的大小
      //     width: 80,
      //     padding: const EdgeInsets.all(5),
      //     margin: const EdgeInsets.only(top: 37), //调整FloatingActionButton的位置

      //     child: FloatingActionButton(
      //       backgroundColor: AppColors.blue1,
      //       child: Container(
      //         margin: const EdgeInsets.all(0.1),
      //         // padding: const EdgeInsets.all(0.5),
      //         child: Flex(
      //             direction: Axis.vertical,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.refresh,
      //                 size: 40,
      //                 color: Colors.white,
      //               ),
      //               Text(
      //                 "刷新",
      //                 style: TextStyle(color: Colors.white, fontSize: 15),
      //               ),
      //             ]),
      //       ),
      //       onPressed: () {
      //         Navigator.pushNamed(context, "/qrDisplay");
      //       },
      //     )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Center(
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
    );
  }
}
