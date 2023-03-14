//以下为文件3-quizSelectionPage.dart中的内容：
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/app_colors.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/QuizInfo.dart';
import '../quiz_models/Quiz_types.dart';
import '../quiz_models/QuizeLoadHelper.dart';
import '../widgets/foldingcell.dart';
import '../Quizs_Page/aQuizPage.dart';

///量表展示栏目，
///加载量表基本信息，从折叠内页跳转 到 问卷入口（目前统一一个）
class QuizSelectionPage extends StatefulWidget {
  const QuizSelectionPage({super.key});
  @override
  QuizSelectionPageState createState() => QuizSelectionPageState();
}

class QuizSelectionPageState extends State<QuizSelectionPage> {
  //实例化一个问卷类
  late List<QuizInfo> quizsList;
  late Future<bool> hasLoadAllQuizsFuture; //用于显示异步加载的flag

  @override
  //状态的重初始化
  void initState() {
    super.initState();
    hasLoadAllQuizsFuture = loadAllQuizs();
  }

//TODO 加载问卷的方式
  Future<bool> loadAllQuizs() async {
    //返回的是json文件路径 string类型
    final quizLoadHelper = QuizLoadHelper(); //实例化 1个文件转化的工具类quizLoadHelper
    quizsList = []; //存放加载后的若干问卷
    for (QuizTypes aQuiztype in QuizTypes.values) {
      final tempquiz =
          await quizLoadHelper.getQuiz(aQuiztype); //get到了QuizInfo类的量表信息
      // 有问题就中断
      if (tempquiz == null) {
        return false;
      }
      quizsList.add(tempquiz);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // MediaQSize.thisDsize = MediaQuery.of(context).size;
    // print(MediaQSize.thisDsize); // 参考7寸Size(600.0, 912.0)，10寸:Size(800.0, 1232.0)
    //调用函数 获取设备尺寸信息和缩放比
    MediaQSize().initMQ(context); //唯一一页
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
        centerTitle: true,

        // leading: IconButton(
        //   icon: const Icon(Icons.home),
        //   tooltip: "回到量表主页",
        //   iconSize: 30,
        // onPressed: () {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     "/",
        //     ModalRoute.withName('/'),
        //   ); //改为pushReplacementNamed
        // },
        // ),
        title: SizedBox(
          width: 600 * MediaQSize.widthRefScale, //足够大=父容器的大小
          child: Padding(
            padding: EdgeInsets.only(left: 30 * MediaQSize.widthRefScale),
            child: Text('耳鸣问诊',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (25 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
                ),
          ),
        ),
        actions: [
          // IconButton(
          //   tooltip: "量表本地历史记录",
          //   icon: const Icon(Icons.history_sharp),
          //   iconSize: 30,
          //   onPressed: () {
          //     Navigator.pushNamed(context, "/quizhistory");
          //   },
          // )
          IconButton(
            tooltip: "清空",
            icon: const Icon(Icons.refresh_outlined),
            iconSize: 30 * MediaQSize.heightRefScale,
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // user must tap button for close dialog!
                builder: (BuildContext context) {
                  return AlertDialog(
                    // alignment: Alignment.center,
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    title: Text(
                      '确认重置数据吗？',
                      style:
                          TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
                    ),
                    content: const Text('此前的本地量表数据和二维码将重置，并重新记录'),
                    actions: <Widget>[
                      MaterialButton(
                        color: AppColors.buledark,
                        child: Text(
                          '否，继续作答',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 * MediaQSize.heightRefScale),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      MaterialButton(
                        color: Colors.red[400],
                        child: Text(
                          '是，确认重置',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 * MediaQSize.heightRefScale),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          StoreQuizs.clearAllQuizs();
                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              );
              setState(() {});
            },
          ),
        ],
      ),
      // floatingActionButton: Container(
      //   height: 70, //调整FloatingActionButton的大小
      //   width: 70,
      //   padding: const EdgeInsets.all(5),
      //   margin: const EdgeInsets.only(top: 37), //调整FloatingActionButton的位置
      //   child: FloatingActionButton(
      //       child: const Icon(
      //         // Icons.play_circle_fill_outlined,
      //         Icons.qr_code,
      //         color: Colors.black,
      //         size: 55,
      //       ), //浮动组件的图标
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/qrDisplay');
      //       }),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked, //配置浮动按钮的位置

      body: FutureBuilder(
        future: hasLoadAllQuizsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return
                //替换 逐个展示
                //TODO:fold展开的高度要调节一下
                ListView(
              children: <Widget>[
                //THI量表
                FoldingCell.create(
                  // unfoldCell: true,//会导致默认打开
                  frontWidget: _buildFrontWidget(quizsList[0]),
                  innerWidget: _buildInnerWidget(quizsList[0]),
                  cellSize: Size(MediaQSize.thisDsize.width,
                      140 * MediaQSize.heightRefScale),
                  padding: EdgeInsets.only(
                      top: 9 * MediaQSize.heightRefScale,
                      bottom: 9 * MediaQSize.heightRefScale,
                      left: 15 * MediaQSize.widthRefScale,
                      right: 15 * MediaQSize.widthRefScale),
                  animationDuration: const Duration(milliseconds: 300),
                  borderRadius: 5,
                  onOpen: () => log('cell 1 opened'),
                  onClose: () => log('cell 1 closed'),
                ),
                //第二个 VAS
                FoldingCell.create(
                  frontWidget: _buildFrontWidget(quizsList[1]),
                  innerWidget: _buildInnerWidget(quizsList[1]),
                  cellSize: Size(MediaQSize.thisDsize.width,
                      90 * MediaQSize.heightRefScale),
                  padding: EdgeInsets.only(
                      top: 9 * MediaQSize.heightRefScale,
                      bottom: 9 * MediaQSize.heightRefScale,
                      left: 15 * MediaQSize.widthRefScale,
                      right: 15 * MediaQSize.widthRefScale),
                  animationDuration: const Duration(milliseconds: 300),
                  borderRadius: 10,
                  onOpen: () => log('cell 2 opened'),
                  onClose: () => log('cell 2 closed'),
                ),
                //第三个TFI
                FoldingCell.create(
                  frontWidget: _buildFrontWidget(quizsList[2]),
                  innerWidget: _buildInnerWidget(quizsList[2]),
                  cellSize: Size(MediaQSize.thisDsize.width,
                      100 * MediaQSize.heightRefScale),
                  padding: EdgeInsets.only(
                      top: 9 * MediaQSize.heightRefScale,
                      bottom: 9 * MediaQSize.heightRefScale,
                      left: 15 * MediaQSize.widthRefScale,
                      right: 15 * MediaQSize.widthRefScale),
                  animationDuration: const Duration(milliseconds: 300),
                  borderRadius: 10,
                  onOpen: () => log('cell 3 opened'),
                  onClose: () => log('cell 3 closed'),
                ),
                //第4个 SAS
                FoldingCell.create(
                  frontWidget: _buildFrontWidget(quizsList[3]),
                  innerWidget: _buildInnerWidget(quizsList[3]),
                  cellSize: Size(MediaQSize.thisDsize.width,
                      120 * MediaQSize.heightRefScale),
                  padding: EdgeInsets.only(
                      top: 9 * MediaQSize.heightRefScale,
                      bottom: 9 * MediaQSize.heightRefScale,
                      left: 15 * MediaQSize.widthRefScale,
                      right: 15 * MediaQSize.widthRefScale),
                  animationDuration: const Duration(milliseconds: 300),
                  borderRadius: 10,
                  onOpen: () => log('cell 4 opened'),
                  onClose: () => log('cell 4 closed'),
                ),
                //第5个 PSQI
                FoldingCell.create(
                  frontWidget: _buildFrontWidget(quizsList[4]),
                  innerWidget: _buildInnerWidget(quizsList[4]),
                  cellSize: Size(MediaQSize.thisDsize.width,
                      90 * MediaQSize.heightRefScale),
                  padding: EdgeInsets.only(
                      top: 9 * MediaQSize.heightRefScale,
                      bottom: 9 * MediaQSize.heightRefScale,
                      left: 15 * MediaQSize.widthRefScale,
                      right: 15 * MediaQSize.widthRefScale),
                  animationDuration: const Duration(milliseconds: 300),
                  borderRadius: 10,
                  onOpen: () => log('cell 5 opened'),
                  onClose: () => log('cell 5 closed'),
                ),
              ],
            );
          } else if (snapshot.hasError ||
              (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == false)) {
            return AlertDialog(
              title: const Text('加载出错!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('重试'),
                  onPressed: () => setState(() {
                    hasLoadAllQuizsFuture = loadAllQuizs();
                  }),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(), //加载中的提示动画
            );
          }
        },
      ),
    );
  }
}

//折叠问卷之 封面页 构造函数 传入问卷名
Widget _buildFrontWidget(QuizInfo chosenquiz) {
  String title = chosenquiz.quizName;
  return Builder(builder: (BuildContext context) {
    return Container(
      color: AppColors.yellowfolds1,
      // color: AppColors.buledark,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(title,
                style: TextStyle(
                    fontSize: 20 * MediaQSize.heightRefScale,
                    fontWeight: FontWeight.bold)),
          ),
          Positioned(
            right: 10 * MediaQSize.widthRefScale,
            bottom: 10 * MediaQSize.heightRefScale,
            child: TextButton.icon(
              label: Text(
                "详情",
                style: TextStyle(
                    fontSize: 15 * MediaQSize.heightRefScale,
                    fontWeight: FontWeight.w500),
              ),
              icon: Icon(
                Icons.expand_more,
                size: 20 * MediaQSize.heightRefScale,
              ),
              onPressed: () {
                final foldingCellState =
                    context.findAncestorStateOfType<FoldingCellState>();
                foldingCellState?.toggleFold();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(60 * MediaQSize.widthRefScale,
                    30 * MediaQSize.heightRefScale),
              ),
            ),
          )
        ],
      ),
    );
  });
}

//折叠问卷之 内页（展开）构造函数 传入问卷指南，
Widget _buildInnerWidget(QuizInfo chosenquiz) {
  String title = chosenquiz.quizName;
  String instructxt = chosenquiz.quizInstructions;
  return Builder(builder: (context) {
    return Container(
      color: AppColors.innerFolds,
      padding: EdgeInsets.only(top: 5 * MediaQSize.heightRefScale),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20 * MediaQSize.heightRefScale,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(
                left: 20.0 * MediaQSize.widthRefScale,
                right: 20.0 * MediaQSize.widthRefScale,
                bottom: 10.0 * MediaQSize.heightRefScale,
              ),
              // margin: const EdgeInsets.all(30),
              child: Text(
                textAlign: TextAlign.start,
                instructxt,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16 * MediaQSize.heightRefScale, //内页字号
                ),
              ),
            ),
          ),
          //收起按钮
          Positioned(
            right: 5,
            top: 0,
            child: TextButton.icon(
              label: Text("收起",
                  style: TextStyle(
                      fontSize: 16 * MediaQSize.heightRefScale,
                      color: AppColors.darkgray,
                      fontWeight: FontWeight.w100)),
              icon: Icon(Icons.keyboard_arrow_up,
                  size: 25 * MediaQSize.heightRefScale,
                  color: AppColors.darkgray),
              onPressed: () {
                final foldingCellState =
                    context.findAncestorStateOfType<FoldingCellState>();
                foldingCellState?.toggleFold();
              },
              // style: TextButton.styleFrom(
              //   backgroundColor: Colors.white,
              // ),
            ),
          ),

          //开始测试入口
          Positioned(
            right: 5 * MediaQSize.widthRefScale,
            bottom: 5 * MediaQSize.heightRefScale,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QuizPage(chosenquiz: chosenquiz),
              )),
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                "开始测试",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17 * MediaQSize.heightRefScale),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(80, 30) * MediaQSize.heightRefScale,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
