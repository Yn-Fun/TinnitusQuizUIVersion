//以下为文件7-quizLocalHisPage.dart中的内容：
import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/quiz_models/QuizInfo.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';

import '../quiz_pages/aQuizResultPage.dart';
import '../configs/app_colors.dart';
import '../configs/media_QSize.dart';

//量表结果的历史记录
class QuizLocalHisPage extends StatefulWidget {
  const QuizLocalHisPage({super.key});

  @override
  State<QuizLocalHisPage> createState() => _QuizLocalHisPageState();
}

class _QuizLocalHisPageState extends State<QuizLocalHisPage> {
  @override
  Widget build(BuildContext context) {
    // //调用函数 获取设备尺寸信息和缩放比
    // MediaQSize().initMQ(context);
    List<QuizInfo?> LatestList5 = [
      QuizsJust5.THILists?.last,
      QuizsJust5.VASLists?.last,
      QuizsJust5.TFILists?.last,
      QuizsJust5.TEQLists?.last,
      QuizsJust5.PSQILists?.last,
    ];

    //返回量表的分数和程度图的widget组合·
    Widget NIWidgetsPair(whichquiz) {
      var idx = whichquiz;
      var padding2 = Padding(
        padding:
            const EdgeInsets.fromLTRB(0, 0, 0, 0) * MediaQSize.widthRefScale,
        child: idx == 1 //是不是VAS量表
            ? //是VAS 两个分量单独放
            Column(
                children: [
                  //VAS分量1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10 * MediaQSize.widthRefScale),
                      //分量1
                      Text(
                        LatestList5[idx]!
                            .quizusersResult
                            .userAspectScores[0]
                            .aspectScore
                            .toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pPurple),
                      ),
                      SizedBox(width: 10 * MediaQSize.widthRefScale),
                      SizedBox(
                        width: 9.6 * 6 * MediaQSize.widthRefScale,
                        height: 5.2 * 6 * MediaQSize.widthRefScale,
                        child: Image(
                            image: AssetImage(getQuizRankPath(
                                LatestList5[idx]!, 0)), //THI,第二个分量不用管（只对VAS有效）
                            fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  //VAS分量2
                  SizedBox(height: 4 * MediaQSize.widthRefScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10 * MediaQSize.widthRefScale),
                      Text(
                        LatestList5[idx]!
                            .quizusersResult
                            .userAspectScores[1]
                            .aspectScore
                            .toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pPurple),
                      ),
                      SizedBox(width: 10 * MediaQSize.widthRefScale),
                      SizedBox(
                        width: 9.6 * 6 * MediaQSize.widthRefScale,
                        height: 5.2 * 6 * MediaQSize.widthRefScale,
                        child: Image(
                            image: AssetImage(getQuizRankPath(
                                LatestList5[idx]!, 1)), //THI,第二个分量不用管（只对VAS有效）
                            fit: BoxFit.fill),
                      ),
                    ],
                  ),
                ],
              )
            : //不是VAS
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10 * MediaQSize.widthRefScale),
                  Text(
                    LatestList5[idx]!
                        .quizusersResult
                        .userrawscorerd
                        .toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 16 * MediaQSize.heightRefScale,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pPurple),
                  ),
                  SizedBox(width: 10 * MediaQSize.widthRefScale),
                  SizedBox(
                    width: idx == 4
                        ? 20.7 *
                            6 *
                            MediaQSize.widthRefScale //PSQI的程度图比较长 如“睡眠质量xx”
                        : 10 * 6 * MediaQSize.widthRefScale,
                    height: 5.2 * 6 * MediaQSize.widthRefScale,
                    child: Image(
                        image: AssetImage(getQuizRankPath(
                            LatestList5[idx]!, 0)), //THI,第二个分量不用管（只对VAS有效）
                        fit: BoxFit.contain),
                  ),
                ],
              ),
      );

      return padding2;
    }

    Widget NULLWidget() {
      return Text('    暂无',
          style: TextStyle(
            fontSize: 16 * MediaQSize.heightRefScale,
          ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, //不显示默认的小返回键
          centerTitle: true,
          title: Text(
            '量表历史记录',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18 * MediaQSize.heightRefScale,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),

          // leading: IconButton( icon: const Icon(IconData(0xe903, fontFamily: 'Path4icons'),color: Colors.black),
          //   tooltip: "回到量表主页",iconSize: 20,onPressed: () {Navigator.pop(context); //返回不再是二维码
          //   }, ), //如果写了leading就不会有默认的返回键了

          toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
        ),
        body:
            //ListShowbody(), //构造子页面1
            Container(
          height: MediaQSize.thisDsize.height,
          width: MediaQSize.thisDsize.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover)), //背景图

          child: Card(
              //白底
              margin: const EdgeInsets.only(left: 15, top: 20, right: 15) *
                  MediaQSize.widthRefScale,
              color: Colors.white,
              child: ListView(
                children: [
                  //1-1 THI图
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5) *
                              MediaQSize.widthRefScale,
                      height: 107.2 * 0.48 * MediaQSize.heightRefScale,
                      width: 8.8 * 0.48 * MediaQSize.widthRefScale,
                      child: const Image(
                          image: AssetImage("assets/images/THIbar.png"),
                          fit: BoxFit.contain)),
                  //1-2 THI得分+图
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 40) *
                        MediaQSize.widthRefScale,
                    child: Row(
                      children: [
                        //得分二字
                        Text(
                          '得分:',
                          style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                          ),
                        ),
                        //THI图 ⭐
                        (LatestList5[0] == null)
                            ? NULLWidget()
                            : NIWidgetsPair(0),
                      ],
                    ),
                  ),
                  //1-3 THI子项
                  if (LatestList5[0] != null)
                    Container(
                        padding: EdgeInsets.only(
                            left: 35 * MediaQSize.widthRefScale,
                            top: 5 * MediaQSize.heightRefScale),
                        height: 24.45 *
                            5 *
                            MediaQSize.widthRefScale, //？不知道为什么UI比例不对 已经微调了
                        width: 103.1 * 5 * MediaQSize.widthRefScale,
                        child: Stack(
                          children: [
                            const Image(
                                image: AssetImage("assets/images/thiSub.png"),
                                fit: BoxFit.fitWidth),
                            //铺上子项分数数值
                            Positioned(
                              right: 100 * MediaQSize.widthRefScale,
                              top: 10 * MediaQSize.widthRefScale,
                              child: SizedBox(
                                height: 93 * MediaQSize.widthRefScale,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${LatestList5[0]?.quizusersResult.userAspectScores[0].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[0]?.quizusersResult.userAspectScores[1].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[0]?.quizusersResult.userAspectScores[2].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  SizedBox(height: 15 * MediaQSize.heightRefScale), //间隔

                  //2-1 VAS
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5) *
                              MediaQSize.widthRefScale,
                      height: 107.2 * 0.48 * MediaQSize.heightRefScale,
                      width: 8.8 * 0.48 * MediaQSize.widthRefScale,
                      child: const Image(
                          image: AssetImage("assets/images/VASbar.png"),
                          fit: BoxFit.contain)),
                  //2-2 VAS得分+图
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 40) *
                        MediaQSize.widthRefScale,
                    child: Row(
                      children: [
                        //得分二字
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '声响程度得分：',
                              style: TextStyle(
                                  fontSize: 16 * MediaQSize.heightRefScale,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10 * MediaQSize.widthRefScale),
                            Text(
                              '烦躁程度得分：',
                              style: TextStyle(
                                  fontSize: 16 * MediaQSize.heightRefScale,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),

                        //VAS图 ⭐
                        (LatestList5[1] == null)
                            ? NULLWidget()
                            : NIWidgetsPair(1),
                      ],
                    ),
                  ),
                  SizedBox(height: 15 * MediaQSize.heightRefScale), //间隔

                  //3-1 TFI图
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5) *
                              MediaQSize.widthRefScale,
                      height: 107.2 * 0.48 * MediaQSize.heightRefScale,
                      width: 8.8 * 0.48 * MediaQSize.widthRefScale,
                      child: const Image(
                          image: AssetImage("assets/images/TFIbar.png"),
                          fit: BoxFit.contain)),
                  //3-2 TFI得分+图
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 40) *
                        MediaQSize.widthRefScale,
                    child: Row(
                      children: [
                        //得分二字
                        Text(
                          '得分:',
                          style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                          ),
                        ),
                        //TFI图 ⭐
                        (LatestList5[2] == null)
                            ? NULLWidget()
                            : NIWidgetsPair(2),
                      ],
                    ),
                  ),
                  //3-3 TFI子项
                  if (LatestList5[2] != null)
                    Container(
                        padding: EdgeInsets.only(
                            left: 35 * MediaQSize.widthRefScale,
                            top: 5 * MediaQSize.heightRefScale),
                        height: 53.2 * 5 * MediaQSize.widthRefScale,
                        width: 103.1 * 5 * MediaQSize.widthRefScale,
                        child: Stack(
                          children: [
                            const Image(
                                image: AssetImage("assets/images/tfiSub.png"),
                                fit: BoxFit.fitWidth),
                            //铺上子项分数数值 TFI共有9个 改进TODO：可以写个循环
                            Positioned(
                              right: 100 * MediaQSize.widthRefScale,
                              top: 17 * MediaQSize.widthRefScale,
                              child: SizedBox(
                                height: 225 * MediaQSize.widthRefScale,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[0].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[1].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[2].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[3].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[4].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[5].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[6].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[2]?.quizusersResult.userAspectScores[7].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  SizedBox(height: 15 * MediaQSize.heightRefScale), //间隔

                  //4-1 TEQbar图
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5) *
                              MediaQSize.widthRefScale,
                      height: 107.2 * 0.48 * MediaQSize.heightRefScale,
                      width: 8.8 * 0.48 * MediaQSize.widthRefScale,
                      child: const Image(
                          image: AssetImage("assets/images/TEQbar.png"),
                          fit: BoxFit.contain)),
                  //4-2 TEQ得分+图
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 40) *
                        MediaQSize.widthRefScale,
                    child: Row(
                      children: [
                        //得分二字
                        Text(
                          '得分:',
                          style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                          ),
                        ),
                        //TEQ图 ⭐
                        (LatestList5[3] == null)
                            ? NULLWidget()
                            : NIWidgetsPair(3),
                      ],
                    ),
                  ),
                  //4-3 TEQ子项
                  if (LatestList5[3] != null)
                    Container(
                        padding: EdgeInsets.only(
                            left: 35 * MediaQSize.widthRefScale,
                            top: 5 * MediaQSize.heightRefScale),
                        height: 39 * 5 * MediaQSize.widthRefScale,
                        width: 103.1 * 5 * MediaQSize.widthRefScale,
                        child: Stack(
                          children: [
                            const Image(
                                image: AssetImage("assets/images/teqSub.png"),
                                fit: BoxFit.fitWidth),
                            //铺上子项分数数值 TEQ共有6个 改进TODO：可以写个循环
                            Positioned(
                              right: 100 * MediaQSize.widthRefScale,
                              top: 7 * MediaQSize.widthRefScale,
                              child: SizedBox(
                                height: 181 * MediaQSize.widthRefScale,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[0].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[1].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[2].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[3].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[4].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[3]?.quizusersResult.userAspectScores[5].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  SizedBox(height: 15 * MediaQSize.heightRefScale), //间隔

                  //5-1 PSQIbar图
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5) *
                              MediaQSize.widthRefScale,
                      height: 107.2 * 0.48 * MediaQSize.heightRefScale,
                      width: 8.8 * 0.48 * MediaQSize.widthRefScale,
                      child: const Image(
                          image: AssetImage("assets/images/PSQIbar.png"),
                          fit: BoxFit.contain)),
                  //5-2 PSQI得分+图
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 40) *
                        MediaQSize.widthRefScale,
                    child: Row(
                      children: [
                        //得分二字
                        Text(
                          '得分:',
                          style: TextStyle(
                            fontSize: 16 * MediaQSize.heightRefScale,
                          ),
                        ),
                        //PSQI图 ⭐
                        (LatestList5[4] == null)
                            ? NULLWidget()
                            : NIWidgetsPair(4),
                      ],
                    ),
                  ),
                  //5-3 PSQI子项
                  if (LatestList5[4] != null)
                    Container(
                        padding: EdgeInsets.only(
                            left: 35 * MediaQSize.widthRefScale,
                            top: 5 * MediaQSize.heightRefScale),
                        height: 48.3 * 5 * MediaQSize.widthRefScale,
                        width: 103.1 * 5 * MediaQSize.widthRefScale,
                        child: Stack(
                          children: [
                            const Image(
                                image: AssetImage("assets/images/psqiSub.png"),
                                fit: BoxFit.fitWidth),
                            //铺上子项分数数值 TEQ共有6个 改进TODO：可以写个循环
                            Positioned(
                              right: 100 * MediaQSize.widthRefScale,
                              top: 9.7 * MediaQSize.widthRefScale,
                              child: SizedBox(
                                height: 210 * MediaQSize.widthRefScale,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[0].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[1].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[2].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[3].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[4].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[5].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${LatestList5[4]?.quizusersResult.userAspectScores[6].aspectScore}  分',
                                      style: TextStyle(
                                          fontSize:
                                              14 * MediaQSize.widthRefScale,
                                          color: AppColors.pPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                ],
              )),
        ));
  }
}
