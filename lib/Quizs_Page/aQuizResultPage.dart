//以下为文件5-aQuizResultPage.dart中的内容：

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
    print("进入结果界面");

    // print(chosenquiz.quizusersResult.userAspectScores[0]);//debug
    int numaspects = chosenquiz.quizusersResult.userAspectScores.length;
    List listAspectsData = []..length = numaspects;

    String quizName = chosenquiz.quizName; //以appbar上标注
    String resultRank = chosenquiz.quizusersResult.userrankrd;
    double rawscore = chosenquiz.quizusersResult.userrawscorerd; //
    print(
      "quizName:$quizName,resultRank:$resultRank,rawscore:$rawscore",
    );
    print("进入scaffold");

    print("aspects细分类别数：$numaspects");
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          tooltip: "返回",
          iconSize: 30 * MediaQSize.heightRefScale,
          onPressed: () {
            //独特的来一个pop
            Navigator.pop(context);
          },
        ),
        // centerTitle: true,

        title: Text(quizName,
            style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
        //结果界面不进入历史记录
        //actions: [
        //   Row(
        //     children: [
        //       IconButton(
        //         tooltip: "量表本地历史记录",
        //         icon: const Icon(Icons.history_sharp),
        //         iconSize: 30,
        //         onPressed: () {
        //           Navigator.pushNamed(context, "/quizhistory"); //结果界面 可以保留返回界面
        //         },
        //       ),
        //     ],
        //   )
        // ],
      ),

      floatingActionButton: Container(
        height: 70 * MediaQSize.heightRefScale, //调整FloatingActionButton的大小
        width: 70 * MediaQSize.heightRefScale,
        padding: const EdgeInsets.all(5) * MediaQSize.heightRefScale,
        margin: const EdgeInsets.only(top: 37) *
            MediaQSize.heightRefScale, //调整FloatingActionButton的位置

        child: FloatingActionButton(
            child: Icon(
              // Icons.play_circle_fill_outlined,
              Icons.qr_code,
              color: Colors.black,
              size: 50 * MediaQSize.heightRefScale,
            ), //浮动组件的图标
            onPressed: () {
              Navigator.pushNamed(context, '/qrDisplay');
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
                    MediaQSize.heightRefScale, //整页内的元素
                child: ListView(
                  children: [
                    //1-外 题头
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 40) *
                          MediaQSize.heightRefScale,
                      child: Text(
                        '您的得分为:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28 * MediaQSize.heightRefScale,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    //2-3 sizebox + card内有
                    Card(
                      margin: const EdgeInsets.only(left: 30, right: 30) *
                          MediaQSize.heightRefScale, //与外界的margin
                      elevation: 5 * MediaQSize.heightRefScale,
                      //card共有，但从collumn 分出两种情况
                      child: chosenquiz.quizName != "视觉模拟量表（VAS）"
                          ?
                          //Column1：如果不是VAS ——正常
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  height: 30 * MediaQSize.heightRefScale,
                                ),
                                //2-总分（程度）
                                Text(
                                  " ${rawscore.toStringAsFixed(0)} 分 （$resultRank）", //显示的结果时 四舍五入之后保留0位数字
                                  style: TextStyle(
                                      fontSize: 30 * MediaQSize.heightRefScale,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.darkred),
                                ),
                                SizedBox(
                                    height: 30 * MediaQSize.heightRefScale),
                                //子项得分情列表
                                Column(
                                  children: _listView(listAspectsData),
                                ),
                                SizedBox(
                                  height: 25 * MediaQSize.heightRefScale,
                                ),
                              ],

                              //
                            )
                          : //Column2：如果是VAS
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center, //居中
                              children: <Widget>[
                                //2-总分（程度）
                                Padding(
                                  padding: EdgeInsets.all(
                                      15 * MediaQSize.heightRefScale),
                                  child: Text(
                                    "声响程度：${chosenquiz.quizusersResult.userAspectScores[0].aspectScore.toStringAsFixed(0)} 分", //显示的结果时 四舍五入之后保留0位数字的
                                    style: TextStyle(
                                        fontSize:
                                            30 * MediaQSize.heightRefScale,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkred),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 5 * MediaQSize.heightRefScale),
                                  child: Text(
                                    "（${chosenquiz.quizusersResult.userAspectScores[0].aspectRank_VAS}）",
                                    style: TextStyle(
                                        fontSize:
                                            25 * MediaQSize.heightRefScale,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding: EdgeInsets.all(
                                      15 * MediaQSize.heightRefScale),
                                  child: Text(
                                    "烦躁程度：${chosenquiz.quizusersResult.userAspectScores[1].aspectScore.toStringAsFixed(0)} 分", //显示的结果时 四舍五入之后保留0位数字的
                                    style: TextStyle(
                                        fontSize:
                                            30 * MediaQSize.heightRefScale,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkred),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 5 * MediaQSize.heightRefScale),
                                  child: Text(
                                    "（${chosenquiz.quizusersResult.userAspectScores[1].aspectRank_VAS}）",
                                    style: TextStyle(
                                        fontSize:
                                            25 * MediaQSize.heightRefScale,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              ],

                              //
                            ), //显示的结果时 四舍五入之后保留0位数字的
                    ),

                    //4-返回按钮
                    Padding(
                      padding: const EdgeInsets.only(
                              top: 50, left: 100, right: 100) *
                          MediaQSize.heightRefScale,
                      child: SizedBox(
                        height: 50 * MediaQSize.heightRefScale,
                        child: MyButton(
                          buttonLabel: '返回量表主页', //单纯pop返回
                          onPressed: () {
                            Navigator.pop(context); //堆栈只剩下主页 且显示的是第一分页
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

  List<Widget> _listView(List<dynamic> listAspectsData) {
    return listAspectsData
        .map((f) => Padding(
              padding: EdgeInsets.only(top: 5 * MediaQSize.heightRefScale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //居中
                children: [
                  Text(
                    f,
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale),
                    // textAlign: TextAlign.left,//没有用 需要设column才行
                  ),
                  const Divider(),
                ],
              ),
            ))
        .toList();
  }
}
