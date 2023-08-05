//以下为文件5-aQuizResultPage.dart中的内容：

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/app_colors.dart';
import 'package:tinnitus_quizs/configs/media_QSize.dart';
import '../quiz_models/QuizInfo.dart';
import '../widgets/mybutton.dart';

class ResultPage extends StatelessWidget {
  QuizInfo chosenquiz; //传入的参数：点选中的某量表
  ResultPage({super.key, required this.chosenquiz}); //构造函数
  //TODO 改一下设置  目前覆盖了看不到  作用域
//传入
//TODO: 结果返回界面
  @override
  Widget build(BuildContext context) {
    int numaspects = chosenquiz.quizusersResult.userAspectScores.length;
    List listAspectsData = []..length = numaspects;

    String quizName = chosenquiz.quizName; //以appbar上标注
    String resultRank = chosenquiz.quizusersResult.userrankrd;
    double rawscore = chosenquiz.quizusersResult.userrawscorerd; //
    log("quizName:$quizName,resultRank:$resultRank,rawscore:$rawscore");
    log("进入scaffold");
    log("aspects细分类别数：$numaspects");
    List listAspectName = []..length = numaspects;
    List listAspectScore = []..length = numaspects;
    //把各个方面的名称+分数 串联起来
    for (int i = 0; i < numaspects; i++) {
      listAspectName[i] =
          chosenquiz.quizusersResult.userAspectScores[i].aspectName;
      listAspectScore[i] = chosenquiz
          .quizusersResult.userAspectScores[i].aspectScore
          .toStringAsFixed(0); //各子项得分也四舍五路保留0位小数
      listAspectsData[i] = "${listAspectName[i]}：${listAspectScore[i]} 分 ";
    }
    print("listAspectsData:$listAspectsData"); //测试一下

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,
        title: Text(
          chosenquiz.quizName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18 * MediaQSize.heightRefScale,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(IconData(0xe903, fontFamily: 'Path4icons'),
              color: Colors.black),
          tooltip: "返回",
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ), //如果写了leading就不会有默认的返回键了
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
      ),

      floatingActionButton: Container(
        height: 70 * MediaQSize.heightRefScale, //调整FloatingActionButton的大小
        width: 70 * MediaQSize.heightRefScale,
        padding: const EdgeInsets.all(5) * MediaQSize.heightRefScale,
        margin: const EdgeInsets.only(top: 37) *
            MediaQSize.heightRefScale, //调整FloatingActionButton的位置
        child: FloatingActionButton(
            backgroundColor: AppColors.pPurple,
            child: Icon(const IconData(0xe901, fontFamily: 'BT3icons'),
                color: Colors.white,
                size: 40 * MediaQSize.heightRefScale), //浮动组件的图标
            onPressed: () {
              Navigator.pushNamed(context, '/qrDisplay'); //加载二维码，但可以返回
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, //配置浮动按钮的位置
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Center(
          //LayoutBuilder组件可以用于做横竖屏
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: const EdgeInsets.all(10) *
                    MediaQSize.widthRefScale, //整页内的元素
                child: ListView(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(left: 20, right: 20) *
                          MediaQSize.widthRefScale, //与外界的margin
                      // elevation: 5 * MediaQSize.heightRefScale,
                      //card共有，但从column 分出两种情况
                      child: chosenquiz.quizName != "视觉模拟量表（VAS）"
                          ? //如果不是VAS —— 其余四个有子项
                          Container(
                              width: 115.2 * 6 * MediaQSize.widthRefScale,
                              height: (chosenquiz.quizName == "耳鸣致残量表（THI）")
                                  ? 70 * 6 * MediaQSize.widthRefScale
                                  : (chosenquiz.quizName == "耳鸣功能指数量表（TFI）")
                                      ? 104 * 6 * MediaQSize.widthRefScale
                                      : (chosenquiz.quizName == "耳鸣评价量表（TEQ）")
                                          ? 89.6 * 6 * MediaQSize.widthRefScale
                                          : (chosenquiz.quizName ==
                                                  "匹兹堡睡眠质量指数量表（PSQI）")
                                              ? 96.8 *
                                                  6 *
                                                  MediaQSize.widthRefScale
                                              : 200 *
                                                  6 *
                                                  MediaQSize.widthRefScale,
                              margin: const EdgeInsets.only(top: 15) *
                                  MediaQSize.widthRefScale,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${chosenquiz.quizName}Result.png"), //四种结果背景
                                      fit: BoxFit.fitWidth)),
                              child: Stack(
                                children: [
                                  //得分+程度的pair
                                  Padding(
                                    padding: const EdgeInsets.only(
                                            left: 20, top: 100) *
                                        MediaQSize.widthRefScale,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          chosenquiz
                                              .quizusersResult.userrawscorerd
                                              .toStringAsFixed(
                                                  0), //显示的结果时 四舍五入之后保留0位数字的
                                          style: TextStyle(
                                              fontSize:
                                                  40 * MediaQSize.widthRefScale,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.pPurple),
                                        ),
                                        SizedBox(
                                            width:
                                                5 * MediaQSize.widthRefScale),
                                        SizedBox(
                                          width: chosenquiz.quizName ==
                                                  "匹兹堡睡眠质量指数量表（PSQI）"
                                              ? 20.8 *
                                                  6 *
                                                  MediaQSize.widthRefScale
                                              : 11.2 *
                                                  6 *
                                                  MediaQSize.widthRefScale,
                                          height: 5.8 *
                                              6 *
                                              MediaQSize.widthRefScale,
                                          child: Image(
                                              image: AssetImage(getQuizRankPath(
                                                  chosenquiz,
                                                  0)), //程度图 第二个分量不用管
                                              fit: BoxFit.contain),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //1/4 THI子项
                                  if (chosenquiz.quizName == "耳鸣致残量表（THI）")
                                    Positioned(
                                      right: 180 * MediaQSize.widthRefScale,
                                      bottom: 87 * MediaQSize.widthRefScale,
                                      child: SizedBox(
                                        height: 115 * MediaQSize.widthRefScale,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[0].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[1].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[2].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  //2/4 TFI子项
                                  if (chosenquiz.quizName == "耳鸣功能指数量表（TFI）")
                                    Positioned(
                                      right: 120 * MediaQSize.widthRefScale,
                                      bottom: 99.5 * MediaQSize.widthRefScale,
                                      child: SizedBox(
                                        height: 283 * MediaQSize.widthRefScale,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[0].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[1].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[2].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[3].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[4].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[5].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[6].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[7].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  //3/4 TEQ子项 6个
                                  if (chosenquiz.quizName == "耳鸣评价量表（TEQ）")
                                    Positioned(
                                      right: 130 * MediaQSize.widthRefScale,
                                      bottom: 90 * MediaQSize.widthRefScale,
                                      child: SizedBox(
                                        height:
                                            216.5 * MediaQSize.widthRefScale,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[0].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[1].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[2].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[3].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[4].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[5].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  //4/4 PSQI子项
                                  if (chosenquiz.quizName ==
                                      "匹兹堡睡眠质量指数量表（PSQI）")
                                    Positioned(
                                      right: 180 * MediaQSize.widthRefScale,
                                      bottom: 95 * MediaQSize.widthRefScale,
                                      child: SizedBox(
                                        height: 250 * MediaQSize.widthRefScale,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[0].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[1].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[2].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[3].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[4].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[5].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${chosenquiz.quizusersResult.userAspectScores[6].aspectScore}  分',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQSize.widthRefScale,
                                                  color: AppColors.pPurple,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          : //Column2：如果是VAS
                          Container(
                              height: 87 * 5.5 * MediaQSize.widthRefScale,
                              width: 115.2 * 5.5 * MediaQSize.widthRefScale,
                              padding: const EdgeInsets.only(top: 5) *
                                  MediaQSize.heightRefScale,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/视觉模拟量表（VAS）Result.png"),
                                      fit: BoxFit.fitWidth)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //分量1：声响分数+程度
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                            0, 100, 0, 80) *
                                        MediaQSize.widthRefScale,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          chosenquiz.quizusersResult
                                              .userAspectScores[0].aspectScore
                                              .toStringAsFixed(
                                                  0), //显示的结果时 四舍五入之后保留0位数字的
                                          style: TextStyle(
                                              fontSize:
                                                  40 * MediaQSize.widthRefScale,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.pPurple),
                                        ),
                                        SizedBox(
                                            width:
                                                20 * MediaQSize.widthRefScale),
                                        SizedBox(
                                          width: 11.2 *
                                              6 *
                                              MediaQSize.widthRefScale,
                                          height: 5.8 *
                                              6 *
                                              MediaQSize.widthRefScale,
                                          child: Image(
                                              image: AssetImage(getQuizRankPath(
                                                  chosenquiz, 0)), //VAS的第一个分量
                                              fit: BoxFit.contain),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //分量2：烦躁分数+程度
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0) *
                                            MediaQSize.widthRefScale,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          chosenquiz.quizusersResult
                                              .userAspectScores[1].aspectScore
                                              .toStringAsFixed(
                                                  0), //显示的结果时 四舍五入之后保留0位数字的
                                          style: TextStyle(
                                              fontSize:
                                                  40 * MediaQSize.widthRefScale,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.pPurple),
                                        ),
                                        SizedBox(
                                            width:
                                                20 * MediaQSize.widthRefScale),
                                        SizedBox(
                                          width: 11.2 *
                                              6 *
                                              MediaQSize.widthRefScale,
                                          height: 5.8 *
                                              6 *
                                              MediaQSize.widthRefScale,
                                          child: Image(
                                              image: AssetImage(getQuizRankPath(
                                                  chosenquiz, 1)), //VAS的第2个分量
                                              fit: BoxFit.contain),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    //4-返回按钮
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 25, right: 25) *
                              MediaQSize.heightRefScale,
                      child: SizedBox(
                        height: 50 * MediaQSize.heightRefScale,
                        child: MyButton(
                          buttonLabel: '返回量表主页', //单纯pop返回
                          onPressed: () {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/')); //退出直到
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//输入：当前作答完的量表，
//输出：图片路径 string格式
//功能：根据量表的结果 找到结果页所需的程度图片
String getQuizRankPath(QuizInfo chosenquiz, int vasFlag) {
  String RootPath;
  String quizrankPath;

  switch (chosenquiz.quizName) {
    case "耳鸣致残量表（THI）":
      RootPath = 'assets/images/THIrank';
      switch (chosenquiz.quizusersResult.userrankrd) {
        case "无残疾":
          quizrankPath = '$RootPath/无残疾.png';
          return quizrankPath;
        case "轻度":
          quizrankPath = '$RootPath/轻度.png';
          return quizrankPath;
        case "中度":
          quizrankPath = '$RootPath/中度.png';
          return quizrankPath;
        case "重度":
          quizrankPath = '$RootPath/重度.png';
          return quizrankPath;
        case "灾难性":
          quizrankPath = '$RootPath/灾难性.png';
          return quizrankPath;
        default:
          return RootPath;
      }

    //VAS是两题分别评级
    case "视觉模拟量表（VAS）":
      RootPath = 'assets/images/VASrank';
      if (vasFlag == 0) {
        switch (chosenquiz.quizusersResult.userAspectScores[0].aspectRank_VAS) {
          case "没有":
            quizrankPath = '$RootPath/没有.png';
            return quizrankPath;

          case "轻微":
            quizrankPath = '$RootPath/轻微.png';
            return quizrankPath;

          case "轻度":
            quizrankPath = '$RootPath/轻度.png';
            return quizrankPath;

          case "中度":
            quizrankPath = '$RootPath/中度.png';
            return quizrankPath;

          case "重度":
            quizrankPath = '$RootPath/重度.png';
            return quizrankPath;

          case "剧烈":
            quizrankPath = '$RootPath/剧烈.png';
            return quizrankPath;

          default:
            log(chosenquiz.quizusersResult.userrankrd);
            return RootPath;
        }
      } else {
        switch (chosenquiz.quizusersResult.userAspectScores[1].aspectRank_VAS) {
          case "没有":
            quizrankPath = '$RootPath/没有.png';
            return quizrankPath;

          case "轻微":
            quizrankPath = '$RootPath/轻微.png';
            return quizrankPath;

          case "轻度":
            quizrankPath = '$RootPath/轻度.png';
            return quizrankPath;

          case "中度":
            quizrankPath = '$RootPath/中度.png';
            return quizrankPath;

          case "重度":
            quizrankPath = '$RootPath/重度.png';
            return quizrankPath;

          case "剧烈":
            quizrankPath = '$RootPath/剧烈.png';
            return quizrankPath;

          default:
            log(chosenquiz.quizusersResult.userrankrd);
            return RootPath;
        }
      }

    case "耳鸣功能指数量表（TFI）":
      RootPath = 'assets/images/TFIrank';
      switch (chosenquiz.quizusersResult.userrankrd) {
        case "轻微":
          quizrankPath = '$RootPath/轻微.png';
          return quizrankPath;
        case "轻度":
          quizrankPath = '$RootPath/轻度.png';
          return quizrankPath;
        case "中度":
          quizrankPath = '$RootPath/中度.png';
          return quizrankPath;
        case "重度":
          quizrankPath = '$RootPath/重度.png';
          return quizrankPath;
        case "极重度":
          quizrankPath = '$RootPath/极重度.png';
          return quizrankPath;
        default:
          return RootPath;
      }

    case "耳鸣评价量表（TEQ）":
      RootPath = 'assets/images/TEQrank';
      switch (chosenquiz.quizusersResult.userrankrd) {
        case "无耳鸣":
          quizrankPath = '$RootPath/无耳鸣.png';
          return quizrankPath;
        case "I级":
          quizrankPath = '$RootPath/I级.png';
          return quizrankPath;
        case "Ⅱ级":
          quizrankPath = '$RootPath/Ⅱ级.png';
          return quizrankPath;
        case "Ⅲ级":
          quizrankPath = '$RootPath/Ⅲ级.png';
          return quizrankPath;
        case "Ⅳ级":
          quizrankPath = '$RootPath/Ⅳ级.png';
          return quizrankPath;
        case "V级":
          quizrankPath = '$RootPath/V级.png';
          return quizrankPath;
        default:
          return RootPath;
      }

    case "匹兹堡睡眠质量指数量表（PSQI）":
      RootPath = 'assets/images/PSQIrank';
      switch (chosenquiz.quizusersResult.userrankrd) {
        case "睡眠质量很好":
          quizrankPath = '$RootPath/睡眠质量很好.png';
          return quizrankPath;
        case "睡眠质量还行":
          quizrankPath = '$RootPath/睡眠质量还行.png';
          return quizrankPath;
        case "睡眠质量一般":
          quizrankPath = '$RootPath/睡眠质量一般.png';
          return quizrankPath;
        case "睡眠质量很差":
          quizrankPath = '$RootPath/睡眠质量很差.png';
          return quizrankPath;
        default:
          return RootPath;
      }
    default:
      return '';
  }
}
