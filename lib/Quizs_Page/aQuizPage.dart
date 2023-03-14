//以下为文件4-aQuizPage.dart中的内容：
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/material.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/Answer.dart';
import '../quiz_models/PsqiAns.dart';
import '../quiz_models/ResultRankRef.dart';
import '../quiz_models/Question.dart';
import '../quiz_models/QuizInfo.dart';
import '../Quizs_Page/aQuizResultPage.dart';
import 'package:dots_indicator/dots_indicator.dart'; //显式地依赖
import '../configs/app_colors.dart';
import '../widgets/mybutton.dart';
import '../widgets/mytimepicker.dart';
import '../widgets/slider0_10.dart';
import '../widgets/radiotile_options.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';

// 创建THI和SAS的问卷界面
// 传入的是 chosenquiz: QuizIfo类的数据
// 返回的是一个 Scaffold组件

double finalResult = 0; //此问卷的最终得分 最后赋值给
int lastindex = 0; //

// String quizName = '';
class QuizPage extends StatefulWidget {
  final QuizInfo chosenquiz; //传入的参数：点选中的某量表

  //构造函数
  const QuizPage({required this.chosenquiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //利用get才能使用返回函数 进而利用widget
  List<Question> get questions =>
      widget.chosenquiz.quizTextandValues; //questions是题目集
  int questionIndex = 0; //当前题号
  double get currentPosition => questionIndex.toDouble(); //用于进度指引

  Question get currentQuestion =>
      questions[questionIndex]; //currentQuestion是当前题目（描述+答案[选项描述+数值]）

  //对于TFI问卷 利用answer的选项作为滑块描述
  Answer get currentOptionsleft => currentQuestion.answers[0];
  Answer get currentOptionsright => currentQuestion.answers[1];

  int get numberOfQuestions => questions.length; //numberOfQuestions：题目总数

  List<int> chosenOptionOrdinalIndexs =
      []; //所有已回答的“按钮类”题目答案的 所在的选项的“自然序号值" 组成的一个list

  List<num> chosenSliderValues = []; //所有已回答的“滑块类”的值，直接组成结果的list
  PsqiAnsStruct psqiAnsStruct = PsqiAnsStruct();

  // late bool TimeFlag;

  // bool get userHasFinishe => MyTimePicker().userHasFinished; //默认

  //输入 int：PSQI题号的自然顺序（小题）
  //输出 str：提取的有效题头标号
  String getPsqiHeadStr(int order) {
    //原来用于从顿号字符识别中读取题号
    //现在得换掉了
    String HeadStr = '';
    developer.log("order:$order");
    List strABCDE = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    int flag = 0;
    if (order >= 0 && order <= 3) {
      flag = 0;
      developer.log(HeadStr);
      HeadStr = (order + 1).toString();
    }
    if (order >= 4 && order <= 13) {
      // print("1");
      flag = 1;
      HeadStr = 5.toString() + strABCDE[order - 4];
    }
    if (order >= 14 && order <= 18) {
      flag = 2;
      HeadStr = (order - 8).toString();
    }
    if (order >= 19 && order <= 23) {
      HeadStr = 10.toString() + strABCDE[order - 19];
      flag = 3;
    }

    return HeadStr;
  }

  //当前题是否已作答
  bool get userHasFinishedCurrentQuestion {
    if ((widget.chosenquiz.quizName == "耳鸣致残量表（THI）") ||
        (widget.chosenquiz.quizName == "耳鸣评价量表（TEQ）") ||
        (widget.chosenquiz.quizName == "匹兹堡睡眠质量指数量表（PSQI）")) {
      // print(widget.chosenquiz.quizName);
      developer
          .log('userHasFinishedCurrentQuestion 内当前题号：${questionIndex + 1}');
      return (chosenOptionOrdinalIndexs[questionIndex] != null); //自然选项按钮有值

    } else if ((widget.chosenquiz.quizName == "视觉模拟量表（VAS）") ||
        (widget.chosenquiz.quizName == "耳鸣功能指数量表（TFI）")) {
      return (chosenSliderValues[questionIndex] != null); //自然选项按钮有值
    } else {
      return true;
    }
  }

  String get currentinstructions => widget.chosenquiz.quizInstructions; //此问卷的指引

  String getRankStr() {
    // 根据得分 定级
    //3)-存入结果等级
    List<ResultRankRef> Refresultranks =
        widget.chosenquiz.quizResultRankRef; //此量表的分级标准
    for (ResultRankRef rankgrading in Refresultranks) {
      if (finalResult >= rankgrading.rankpoints) {
        return rankgrading.rankdescriptions; //存入结果等级
      } //选用第一个程度最严重的 作为最终结果
    }
    return '出错'; //直到最后还没找到 就是出错了
  }

//返回程度描述(中重度)
  calTHIorPSQIresult() {
    developer.log("按钮计算类别");
    double result = 0;
    int leth = chosenOptionOrdinalIndexs.length;
    //预处理PSQI的几个非常规题
    if (widget.chosenquiz.quizName == "匹兹堡睡眠质量指数量表（PSQI）") {
      if (chosenOptionOrdinalIndexs[18] == 0) {
        //有无室友
        chosenOptionOrdinalIndexs[19] = 0;
        chosenOptionOrdinalIndexs[20] = 0;
        chosenOptionOrdinalIndexs[21] = 0;
        chosenOptionOrdinalIndexs[22] = 0;
        chosenOptionOrdinalIndexs[23] = 0;
      }
    }
    //THI 初始化得在外
    double FAspectScore = 0;
    double EAspectScore = 0;
    double CAspectScore = 0;
    //index是题号
    developer.log('$chosenOptionOrdinalIndexs');

    for (int index = 0; index < leth; index++) {
      Question currentquestion = questions[index]; //当前题目
      int currentOptionOrdinalIndex =
          chosenOptionOrdinalIndexs[index]; //当前题目的作答后的选项“自然顺序值”
      Answer chosenAnswer =
          currentquestion.answers[currentOptionOrdinalIndex]; //当题的答案[选项描述+数值]
      int currentvalue = chosenAnswer.optionvalue; //答案[仅数值value]）

      //先计算各细分aspects分数 或处理一下时间插件赋值

      //1-THI 直接在for之中
      if (widget.chosenquiz.quizName == "耳鸣致残量表（THI）") {
        //对TFI的三个aspects

        if (index + 1 == 1 ||
            index + 1 == 2 ||
            index + 1 == 4 ||
            index + 1 == 7 ||
            index + 1 == 9 ||
            index + 1 == 12 ||
            index + 1 == 13 ||
            index + 1 == 15 ||
            index + 1 == 18 ||
            index + 1 == 20 ||
            index + 1 == 24) {
          FAspectScore += currentvalue;
        }
        if (index + 1 == 3 ||
            index + 1 == 6 ||
            index + 1 == 10 ||
            index + 1 == 14 ||
            index + 1 == 16 ||
            index + 1 == 17 ||
            index + 1 == 21 ||
            index + 1 == 22 ||
            index + 1 == 25) {
          EAspectScore += currentvalue;
        }
        if (index + 1 == 5 ||
            index + 1 == 8 ||
            index + 1 == 11 ||
            index + 1 == 19 ||
            index + 1 == 23) {
          CAspectScore += currentvalue;
        }
        developer.log(
            "截至到${index + 1}题,分数：$result\n F:$FAspectScore; E:$EAspectScore; C:$CAspectScore"); //debug
        widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore =
            FAspectScore;
        widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore =
            EAspectScore;
        widget.chosenquiz.quizusersResult.userAspectScores[2].aspectScore =
            CAspectScore;
      } //if THI

      //计算总分：所有累加
      result += currentvalue;
    } //for循环结束

    //5-PSQI 直接分A-B-C部分计算 不用for循环
    if (widget.chosenquiz.quizName == "匹兹堡睡眠质量指数量表（PSQI）") {
      double psqiAscore = 0; //A.睡眠质量
      double psqiBscore = 0; //B.入睡时间
      double psqiCscore = 0; //C.睡眠时间
      double psqiDscore = 0; //D.睡眠效率
      double psqiEscore = 0; //E.睡眠障碍
      double psqiFscore = 0; //F.催眠药物
      double psqiGscore = 0; //G.日间功能障碍
      //A睡眠质量——第6题  index = 14
      psqiAscore =
          (questions[14].answers[chosenOptionOrdinalIndexs[14]].optionvalue)
              .toDouble();

      //B.入睡时间——累加条目2和5a的计分  index = 1和4
      int sum2_5a =
          (questions[1].answers[chosenOptionOrdinalIndexs[1]].optionvalue +
              questions[4].answers[chosenOptionOrdinalIndexs[4]].optionvalue);
      if (sum2_5a == 0) {
        psqiBscore = 0;
      } else if ((sum2_5a == 1) || (sum2_5a == 2)) {
        psqiBscore = 1;
      } else if ((sum2_5a == 3) || (sum2_5a == 4)) {
        psqiBscore = 2;
      } else if ((sum2_5a == 5) || (sum2_5a == 6)) {
        psqiBscore = 3;
      }

      //C.睡眠时间——第3题 在最近一个月中，您每晚实际睡眠的时间为-?小时
      //“>7小时”计0分，“6~7”计1分，“5~6”计2分，“<5小时”计3分。
      int actualsleeptimeInHour;
      actualsleeptimeInHour = psqiAnsStruct.actualsleeptime.hour;
      developer.log("实际睡眠时间 in hours：$actualsleeptimeInHour");
      if (actualsleeptimeInHour >= 7) {
        psqiCscore = 0;
      } else if (actualsleeptimeInHour == 6) {
        psqiCscore = 1;
      } else if (actualsleeptimeInHour == 5) {
        psqiCscore = 2;
      } else if (actualsleeptimeInHour <= 4) {
        psqiCscore = 3;
      }

      //D.睡眠效率——第4题 在最近一个月中，您每晚实际睡眠的时间为-?小时
      //>85%计0分，75~84%计1分，65~74%计2分，<65%计3分。
      //new DateTime(nowyear, nowmonth, nowday, nowhour, nowmin);
      //计算差值 可以使用difference 和 inminute
      DateTime onDate;
      DateTime offDate;
      double division;
      //专为分钟计算
      double Mindiffbed;
      double Minactualsleep = ((psqiAnsStruct.actualsleeptime.hour) * 60 +
              (psqiAnsStruct.actualsleeptime.minute))
          .toDouble(); //分钟
      //上床时间·
      if (psqiAnsStruct.bedtime.hour <= 12) {
        onDate = DateTime(2022, 1, 2, psqiAnsStruct.bedtime.hour,
            psqiAnsStruct.bedtime.minute);
      } else {
        onDate = DateTime(2022, 1, 1, psqiAnsStruct.bedtime.hour,
            psqiAnsStruct.bedtime.minute);
      }
      offDate = DateTime(2022, 1, 2, psqiAnsStruct.offbedtime.hour,
          psqiAnsStruct.offbedtime.minute); //默认2号
      psqiAnsStruct.diffbedtimedate = offDate.difference(onDate);
      Mindiffbed = (psqiAnsStruct.diffbedtimedate.inMinutes)
          .toDouble(); //duration 型 直接in
      division = Minactualsleep / Mindiffbed;
      developer.log(
          "实际睡眠：${psqiAnsStruct.actualsleeptime};床上时间差：${psqiAnsStruct.diffbedtimedate};睡眠效率$division ");
      if (division >= 0.85) {
        psqiDscore = 0;
      } else if ((division >= 0.75) & (division < 0.85)) {
        psqiDscore = 1;
      } else if ((division >= 0.65) & (division < 0.75)) {
        psqiDscore = 2;
      } else if (division < 0.65) {
        psqiDscore = 3;
      }
      developer.log("睡眠效率得分：$psqiDscore");

      //E.睡眠障碍
      //累加条目5b ~ 5j的计分，若累加分为： index 5~13
      int sum5bj = 0;
      for (int i = 5; i <= 13; i++) {
        sum5bj =
            (questions[i].answers[chosenOptionOrdinalIndexs[i]].optionvalue +
                sum5bj);
      }
      if (sum5bj == 0) {
        psqiEscore = 0;
      } else if ((sum5bj >= 1) & (sum5bj <= 9)) {
        psqiEscore = 1;
      } else if ((sum5bj >= 10) & (sum5bj <= 18)) {
        psqiEscore = 2;
      } else if ((sum5bj >= 19) & (sum5bj <= 27)) {
        psqiEscore = 3;
      }

      // F.催眠药物 根据条目7的应答计分，
      psqiFscore = questions[15]
          .answers[chosenOptionOrdinalIndexs[15]]
          .optionvalue
          .toDouble();

      //G.日间功能障碍 累加条目8和9的得分，
      int sum89 =
          (questions[16].answers[chosenOptionOrdinalIndexs[16]].optionvalue +
              questions[17].answers[chosenOptionOrdinalIndexs[17]].optionvalue);
      if (sum89 == 0) {
        psqiGscore = 0;
      } else if ((sum89 == 1) || (sum89 == 2)) {
        psqiGscore = 1;
      } else if ((sum89 == 3) || (sum89 == 4)) {
        psqiGscore = 2;
      } else if ((sum89 == 5) || (sum89 == 6)) {
        psqiGscore = 3;
      }

      result = psqiAscore +
          psqiBscore +
          psqiCscore +
          psqiDscore +
          psqiEscore +
          psqiFscore +
          psqiGscore; //各部分累加
      widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore =
          psqiAscore;
      widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore =
          psqiBscore;
      widget.chosenquiz.quizusersResult.userAspectScores[2].aspectScore =
          psqiCscore;
      widget.chosenquiz.quizusersResult.userAspectScores[3].aspectScore =
          psqiDscore;
      widget.chosenquiz.quizusersResult.userAspectScores[4].aspectScore =
          psqiEscore;
      widget.chosenquiz.quizusersResult.userAspectScores[5].aspectScore =
          psqiFscore;
      widget.chosenquiz.quizusersResult.userAspectScores[6].aspectScore =
          psqiGscore;
    } //PSQI

    finalResult = result; //存下之后传给展示页
    //1)直接写入总分
    widget.chosenquiz.quizusersResult.userrawscorerd = finalResult;
    // 2)存入原始序号
    widget.chosenquiz.quizusersResult.userrawchoiceIdx =
        chosenOptionOrdinalIndexs;

    // developer.log("内部FAspectScore:${widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore}");//debug
    // developer.log("累计总分数: $finalResult"); //debug
    // 根据得分 定级
    //3)-存入结果等级

    widget.chosenquiz.quizusersResult.userrankrd = getRankStr();
  }

  calslideTFIresult() {
    //补充了归一化到100分
    developer.log("滑块计算类别");
    developer.log("进入：cal_SlideResultRankstr "); //debug
    double result = 0;
    //TFI细分 初始化得放在for之外
    double tfiIscore = 0; //tfi_aspect_score
    double tfiSCscore = 0;
    double tfiCscore = 0;
    double tfiSLscore = 0;
    double tfiAscore = 0;
    double tfiRscore = 0;
    double tfiQscore = 0;
    double tfiEscore = 0;
    //index是题号
    for (int index = 0; index < numberOfQuestions; index++) {
      // developer.log("进入for：index = $index"); //debug
      // developer.log("$chosenSliderValues[index]"); //debug

      num currentvalue = chosenSliderValues[index]; //答案[仅数值value]）
      result += currentvalue; //得分累加
      // bool debuggg = currentOptionOrdinalIndex == currentvalue;
      developer.log("截至到${index + 1}题,分数：$result"); //debug
      //计算各细分aspects分数
      //3-TFI
      if (widget.chosenquiz.quizName == "耳鸣功能指数量表（TFI）") {
        developer.log("耳鸣功能指数量表TFI细分类"); //debug

        if (index + 1 == 1 || index + 1 == 2 || index + 1 == 3) {
          tfiIscore += currentvalue;
        }
        if (index + 1 == 4 || index + 1 == 5 || index + 1 == 6) {
          tfiSCscore += currentvalue;
        }
        if (index + 1 == 7 || index + 1 == 8 || index + 1 == 9) {
          tfiCscore += currentvalue;
        }
        if (index + 1 == 10 || index + 1 == 11 || index + 1 == 12) {
          tfiSLscore += currentvalue;
        }
        if (index + 1 == 13 || index + 1 == 14 || index + 1 == 15) {
          tfiAscore += currentvalue;
        }
        if (index + 1 == 16 || index + 1 == 17 || index + 1 == 18) {
          tfiRscore += currentvalue;
        }
        if (index + 1 == 19 ||
            index + 1 == 20 ||
            index + 1 == 21 ||
            index + 1 == 22) {
          tfiQscore += currentvalue;
        }
        if (index + 1 == 23 || index + 1 == 24 || index + 1 == 25) {
          tfiEscore += currentvalue;
        }
      }
    }

    //存入TFI各子项 百分制 取1位小数后 写入到Quiz中
    widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore =
        double.parse((tfiIscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore =
        double.parse((tfiSCscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[2].aspectScore =
        double.parse((tfiCscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[3].aspectScore =
        double.parse((tfiSLscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[4].aspectScore =
        double.parse((tfiAscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[5].aspectScore =
        double.parse((tfiRscore / 3 * 10).toStringAsFixed(1));
    widget.chosenquiz.quizusersResult.userAspectScores[6].aspectScore =
        double.parse((tfiQscore / 4 * 10).toStringAsFixed(1)); //不一样
    widget.chosenquiz.quizusersResult.userAspectScores[7].aspectScore =
        double.parse((tfiEscore / 3 * 10).toStringAsFixed(1));

    finalResult = result / 25 * 10; //总分注意是直接对各题的平均，而不是子项分量的平均，存下之后传给展示页
    //1)直接写入总分
    widget.chosenquiz.quizusersResult.userrawscorerd = finalResult;
    // 2)存入原始序号
    List<num> lis = [];
    for (var element in chosenSliderValues) {
      lis.add(element.toInt()); //把TFI里面的slide数值化为int存储
    }
    widget.chosenquiz.quizusersResult.userrawchoiceIdx = lis;

    // developer.log("累计总分数: $finalResult"); //debug
    // 根据得分 定级
    //3)-存入结果等级
    widget.chosenquiz.quizusersResult.userrankrd = getRankStr();
  }

  calTEQresult() {
    developer.log("进入：计算TEQ cal_TeqResultRankstr "); //debug
    //TFI细分 初始化得放在for之外
    double TEQ1Circumu = 0; //tfi_aspect_score
    double TEQ2Continu = 0;
    double TEQ3Sleep = 0;
    double TEQ4Work = 0;
    double TEQ5Emot = 0;
    double TEQ6Judge = chosenOptionOrdinalIndexs[5].toDouble();
    double result = chosenOptionOrdinalIndexs[5].toDouble(); //初始化第6项已经加上
    widget.chosenquiz.quizusersResult.userAspectScores[5].aspectScore =
        TEQ6Judge;

    // print(chosenOptionOrdinalIndexs);
    //前五题
    for (int index = 0; index < 5; index++) {
      Question currentquestion = questions[index]; //当前题目
      int currentOptionOrdinalIndex =
          chosenOptionOrdinalIndexs[index]; //当前题目的作答后的选项“自然顺序值”
      Answer chosenAnswer =
          currentquestion.answers[currentOptionOrdinalIndex]; //当题的答案[选项描述+数值]
      int currentvalue = chosenAnswer.optionvalue; //答案[仅数值value]）
      //先计算各细分aspects分数 或处理一下时间插件赋值
      //1-THI 直接在for之中
      if (index + 1 == 1) {
        TEQ1Circumu += currentvalue;
      }
      if (index + 1 == 2) {
        TEQ2Continu += currentvalue;
      }
      if (index + 1 == 3) {
        TEQ3Sleep += currentvalue;
      }
      if (index + 1 == 4) {
        TEQ4Work += currentvalue;
      }
      if (index + 1 == 5) {
        TEQ5Emot += currentvalue;
      }

      //计算总分：所有累加
      result += currentvalue; //前5
    }
    finalResult = result; //存下之后传给展示页
    //1)直接写入总分
    widget.chosenquiz.quizusersResult.userrawscorerd = finalResult;
    //2）各项
    widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore =
        TEQ1Circumu;
    widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore =
        TEQ2Continu;
    widget.chosenquiz.quizusersResult.userAspectScores[2].aspectScore =
        TEQ3Sleep;
    widget.chosenquiz.quizusersResult.userAspectScores[3].aspectScore =
        TEQ4Work;
    widget.chosenquiz.quizusersResult.userAspectScores[4].aspectScore =
        TEQ5Emot;

    // 3)存入原始序号
    //4)-存入结果等级

    widget.chosenquiz.quizusersResult.userrankrd = getRankStr();
  }

  calVASresult() {
    widget.chosenquiz.quizusersResult.userrankrd = ' '; //VAS不用结果等级
    // widget.chosenquiz.quizusersResult.userrawscorerd = 0; //VAS不看总分
    widget.chosenquiz.quizusersResult.userrawchoiceIdx = []; //VAS不计原始序号

    // print("等级计算类别：${widget.chosenquiz.quizusersResult?.userrankrd}");
    // print("VAS不独立一个函数了 直接写");
    //VAS细分为两项  VAS_loud和VAS_annoy
    double VASLoudScore = 0; //vas_aspect_score
    String VASLoudRank = '';
    double VASAnnoyScore = 0;
    String VASAnnoyRank = '';

    // double VASAll = 0;

    //index是题号
    for (int index = 0; index < numberOfQuestions; index++) {
      // print("进入for：index = $index"); //debug
      // print("$chosenSliderValues[index]"); //debug
      num currentvalue = chosenSliderValues[index]; //答案[仅数值value]）
      // VASAll += currentvalue; //得分累加 【没用 但写着】
      if (index + 1 == 1) {
        VASLoudScore += currentvalue;
      }
      if (index + 1 == 2) {
        VASAnnoyScore += currentvalue;
      }
    }

    // 根据得分 定级
    List<ResultRankRef> Refresultranks = //此量表的分级标准
        widget.chosenquiz.quizResultRankRef;
    //自上而下选
    for (ResultRankRef rankgrading in Refresultranks) {
      if (VASLoudScore >= rankgrading.rankpoints) {
        VASLoudRank = rankgrading.rankdescriptions;
        break;
      } //选用第一个程度最严重的 作为最终结果
    }
    for (ResultRankRef rankgrading in Refresultranks) {
      if (VASAnnoyScore >= rankgrading.rankpoints) {
        VASAnnoyRank = rankgrading.rankdescriptions;
        break;
      } //选用第一个程度最严重的 作为最终结果
    }

    // finalResult = VASAll;
    //写入各子项
    widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore =
        VASLoudScore;
    widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore =
        VASAnnoyScore;
    widget.chosenquiz.quizusersResult.userAspectScores[0].aspectRank_VAS =
        VASLoudRank;
    widget.chosenquiz.quizusersResult.userAspectScores[1].aspectRank_VAS =
        VASAnnoyRank;
    //end VAS计算
  }

  @override
  void initState() {
    super.initState();
    print('进入Quizpage的initState');
    questionIndex = 0; //题号归0
    lastindex = 0; //进度球
    print('numberOfQuestions大小：$numberOfQuestions');
    //由于下面两句话 导致必须Running with unsound null safety 得解

    chosenOptionOrdinalIndexs = []..length = numberOfQuestions; //
    chosenSliderValues = []..length = numberOfQuestions; //

    print('结束Quizpage的initState');
  }

  @override
  Widget build(BuildContext context) {
    // //调用函数 获取设备尺寸信息和缩放比
    // MediaQSize().initMQ(context);
    double currentPosition = questionIndex.toDouble(); //用于进度指引
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.chosenquiz.quizName,
                style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              tooltip: "返回",
              iconSize: 30 * MediaQSize.heightRefScale,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: switchWidget(context));
  }

  Widget switchWidget(BuildContext context) {
    switch (widget.chosenquiz.quizName) {
      case "耳鸣致残量表（THI）":
        // print('THI-完成');
        return THIWidget(context);

      case "耳鸣评价量表（TEQ）":
        // print('TEQ-完成-类THI');
        return TEQWidget(context);

      case "视觉模拟量表（VAS）":
        // print('VAS-完成');
        return VASWidget(context);

      case "耳鸣功能指数量表（TFI）":
        return TFIWidget(context);

      case "匹兹堡睡眠质量指数量表（PSQI）":
        return PSQIWidget(context);

      default:
        print('NUll');
        return const Scaffold(
          body: Text("NULL"),
        );
    } //switch
  } //widget

  Widget THIWidget(BuildContext context) {
    double currentPosition = questionIndex.toDouble(); //用于进度指引
    return SafeArea(
      child: ListView(
        children:
            //TODO :把布局再改一下，小圆圈太小了，可以单独列出来
            [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0) *
                MediaQSize.heightRefScale,
            child: Text(
              "第 ${questionIndex + 1} 题 / 共 $numberOfQuestions 题",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25 * MediaQSize.heightRefScale,
                fontWeight: FontWeight.w500,
                color: AppColors.blue1,
              ),
            ),
          ),

          //用sizebo+card显示题目
          //用card来布局，单子组件
          // SizedBox(
          //   height: MediaQSize.thisDsize.height * 0.7,
          //   child:
          // ),
          Card(
              margin: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 30) *
                  MediaQSize.heightRefScale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //进度状态提示小圆圈
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(5.0) * MediaQSize.heightRefScale,
                      child: DotsIndicator(
                        mainAxisSize: MainAxisSize.max, //扩大圈圈间距 好像无效
                        dotsCount: numberOfQuestions,
                        axis: Axis.vertical,
                        position: currentPosition, //questionIndex.toDouble();
                        onTap: (pos) {
                          int posint = pos.toInt();
                          lastindex = max(questionIndex, lastindex);
                          // debug用的
                          // print("当前题号questionIndex: $questionIndex");
                          // print("点到posint: $posint");
                          // print("最后lastindex: $lastindex");
                          // 逻辑：只有回答过的记录可以点击进度球回去查看
                          if (posint <= lastindex) {
                            setState(() => questionIndex = posint);
                          } else {
                            setState(() =>
                                currentPosition = questionIndex.toDouble());
                          }
                        },
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        decorator: DotsDecorator(
                          size:
                              const Size.square(18) * MediaQSize.heightRefScale,
                          activeSize:
                              const Size(25, 25) * MediaQSize.heightRefScale,
                          activeColor: AppColors.bule3,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),
                  //纵隔间距
                  SizedBox(
                    width: 20 * MediaQSize.widthRefScale,
                  ),
                  Expanded(
                    flex: 9,
                    child: Column(
                      //字数过多溢出的问题 通过指定宽度解决了
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15 * MediaQSize.heightRefScale,
                              bottom: 15 * MediaQSize.heightRefScale),
                          child: Text(
                            currentQuestion.questiontext,
                            style: TextStyle(
                                fontSize: 25 * MediaQSize.heightRefScale,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        const Divider(thickness: 5),
                        //选项按钮组
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RadioTileOptions(
                            activeColor: AppColors.blue1, //选中的按钮
                            labelStyle: TextStyle(
                                fontSize:
                                    25 * MediaQSize.heightRefScale), //按键字体
                            labels: currentQuestion.answers
                                .map((answer) => answer.optiontext)
                                .toList(), //label是选项文本的·list
                            //注意自定义的是ifchange 而不是onchanged
                            //输入 string 和 int类
                            //返回一个void函数———重建更新答案
                            //重点是setstate
                            ifChange: (_, answerIndex) => setState(() {
                              //调用重新build
                              chosenOptionOrdinalIndexs[questionIndex] =
                                  answerIndex; //选项的自然顺序
                            }),
                            //进入下一题之前清空所选的记忆
                            picked: !userHasFinishedCurrentQuestion
                                ? ""
                                : currentQuestion
                                    .answers[chosenOptionOrdinalIndexs[
                                        questionIndex]]
                                    .optiontext,
                          ),
                        ),

                        const Divider(thickness: 5),
                        SizedBox(
                          height: 60 * MediaQSize.heightRefScale,
                        ),

                        //上一题下一题
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: OverflowBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                  width: 2 * MediaQSize.heightRefScale), //对中
                              SizedBox(
                                height: 50 * MediaQSize.heightRefScale,
                                child: Visibility(
                                  visible: questionIndex != 0,
                                  //在第一题不出现“上一题”的按钮
                                  child: MyButton(
                                    buttonLabel: ' 上一题 ',
                                    onPressed: onBackButtonPressed,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50 * MediaQSize.heightRefScale,
                                child: Visibility(
                                  visible:
                                      questionIndex != numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 下一题 ',
                                    //前提是完成本题后 才能下一步
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onNextButtonPressed
                                        : null,
                                  ),
                                ),
                              ),
                              //完成设计最后一题 应该出现“提交”而不是下一步
                              SizedBox(
                                height: 50 * MediaQSize.heightRefScale,
                                child: Visibility(
                                  visible:
                                      questionIndex == numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 提  交 ',
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onSummitButtonPressed
                                        : null,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //距离card右边界的间距
                  SizedBox(
                    width: 20 * MediaQSize.widthRefScale,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget VASWidget(BuildContext context) {
    double currentPosition = questionIndex.toDouble(); //用于进度指引
    return ListView(children: [
      Padding(
        padding: EdgeInsets.only(
            left: 15 * MediaQSize.heightRefScale,
            right: 15 * MediaQSize.heightRefScale),
        child: Column(
          children: [
            Text(
              "第 ${questionIndex + 1} 题 / 共 $numberOfQuestions 题",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25 * MediaQSize.heightRefScale,
                fontWeight: FontWeight.w500,
                color: AppColors.blue1, //
              ),
            ),
            SizedBox(
              height: 30 * MediaQSize.heightRefScale,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 10, bottom: 30) *
                  MediaQSize.heightRefScale,
              child: Text(
                currentQuestion.questiontext,
                style: TextStyle(
                    fontSize: 25 * MediaQSize.heightRefScale,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(5.0) * MediaQSize.heightRefScale,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              elevation: 5 * MediaQSize.heightRefScale,
              child: Column(
                children: [
                  SizedBox(
                      // width: 300,
                      // height: 150,
                      child: questionIndex == 0
                          ? Image.asset('assets/images/VAS_loud.png',
                              fit: BoxFit.cover)
                          : Image.asset('assets/images/VAS_annoy.png',
                              fit: BoxFit.cover)),
                  SizedBox(
                    height: 20 * MediaQSize.heightRefScale,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10) *
                        MediaQSize.heightRefScale,
                    child: Text(
                      "请拖动滑块到与您当前状况最相符的位置：",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22 * MediaQSize.heightRefScale,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, //黑色
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30 * MediaQSize.heightRefScale,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0:最小值",
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
                Text("10:最大值",
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0) * MediaQSize.heightRefScale,
              child: Slider0_10(
                usermax: 10,
                usermin: 0,
                isSlideDiscrete: true, //VAS选择连续滑块，[20230106也改为离散的]
                NotReset: false, //细分为两题了，需要为下一题重置
                postSliderValue: chosenSliderValues[questionIndex],
                slideOnChange: (currentSliderValue) => setState(() {
                  chosenSliderValues[questionIndex] =
                      currentSliderValue; //获取slide0-10中的当前值,存入chosenSliderValues
                }),
              ),
            ),
            // const Divider(thickness: 5),//粗线
            SizedBox(
              height: 50 * MediaQSize.heightRefScale,
            ),

            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 2 * MediaQSize.widthRefScale),
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                  child: Visibility(
                    visible: questionIndex != 0,
                    //在第一题不出现“上一题”的按钮
                    child: MyButton(
                      buttonLabel: ' 上一题 ',
                      onPressed: onBackButtonPressed,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                  child: Visibility(
                    visible: questionIndex != numberOfQuestions - 1,
                    child: MyButton(
                      buttonLabel: ' 下一题 ',
                      //前提是完成本题后 才能下一步

                      onPressed: userHasFinishedCurrentQuestion
                          ? onNextButtonPressed
                          : null,
                    ),
                  ),
                ),
                //完成设计最后一题 应该出现“提交”而不是下一步
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                  child: Visibility(
                    visible: questionIndex == numberOfQuestions - 1,
                    child: MyButton(
                      buttonLabel: ' 提  交 ',
                      onPressed: userHasFinishedCurrentQuestion
                          ? onSummitButtonPressed
                          : null,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget TFIWidget(BuildContext context) {
    double currentPosition = questionIndex.toDouble(); //用于进度指引

    String currentOptionsleftStr = currentOptionsleft.optiontext;
    String currentOptionsrightStr = currentOptionsright.optiontext;
    return ListView(
      children:
          //TODO :有空把布局再改一下，小圆圈太小了，可以单独列出来
          [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0) *
              MediaQSize.heightRefScale,
          child: Text(
            "第 ${questionIndex + 1} 题 / 共 $numberOfQuestions 题",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25 * MediaQSize.heightRefScale,
              fontWeight: FontWeight.w500,
              color: AppColors.blue1, //黑色
            ),
          ),
        ),
        //用padding+card显示题目

        Card(
            margin: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 10, bottom: 30) *
                MediaQSize.heightRefScale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //进度状态提示小圆圈
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(5.0) * MediaQSize.heightRefScale,
                    child: DotsIndicator(
                      mainAxisSize: MainAxisSize.max, //扩大圈圈间距

                      dotsCount: numberOfQuestions,
                      axis: Axis.vertical,
                      position: currentPosition, //questionIndex.toDouble();
                      onTap: (pos) {
                        int posint = pos.toInt();
                        lastindex = max(questionIndex, lastindex);
                        //debug用的
                        // print("当前题号questionIndex: $questionIndex");
                        // print("点到posint: $posint");
                        // print("最后lastindex: $lastindex");
                        //逻辑：只有回答过的记录可以点击进度球回去查看
                        if (posint <= lastindex) {
                          setState(() => questionIndex = posint);
                          print("TFI进度题号：${questionIndex + 1}");
                        } else {
                          setState(
                              () => currentPosition = questionIndex.toDouble());
                          print("TFI进度题号：${questionIndex + 1}");
                        }
                      },
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      decorator: DotsDecorator(
                        size: const Size.square(18) * MediaQSize.heightRefScale,
                        activeSize:
                            const Size(25, 25) * MediaQSize.heightRefScale,
                        activeColor: AppColors.bule3,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                ),
                //纵隔间距
                SizedBox(
                  width: 5 * MediaQSize.widthRefScale,
                ),
                //题目文字
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 15 * MediaQSize.heightRefScale),
                      Text(
                        currentQuestion.questiontext,
                        style: TextStyle(
                            fontSize: 25 * MediaQSize.heightRefScale,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(
                        height: 80,
                      ),
                      // const Divider(thickness: 5),
                      // 离散滑块作THI选项
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //不同题 依托currentOptionsleft  展示最高和最低程度
                          Text(currentOptionsleftStr,
                              style: TextStyle(
                                  fontSize: 20 * MediaQSize.heightRefScale)),
                          Text(currentOptionsrightStr,
                              style: TextStyle(
                                  fontSize: 20 * MediaQSize.heightRefScale)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0) *
                            MediaQSize.heightRefScale,
                        child: Slider0_10(
                          usermax: 10,
                          usermin: 0,
                          userdivisions: 10,
                          isSlideDiscrete: true, //选择连续滑块，
                          postSliderValue: chosenSliderValues[questionIndex],

                          slideOnChange: (currentSliderValue) => setState(() {
                            chosenSliderValues[questionIndex] =
                                currentSliderValue; //获取slide0-10中的当前值,存入chosenSliderValues
                          }),
                        ),
                      ),

                      // const Divider(thickness: 5),
                      const SizedBox(
                        height: 100,
                      ),
                      //上一题下一题
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(width: 2 * MediaQSize.widthRefScale),
                          SizedBox(
                            height: 50 * MediaQSize.heightRefScale,
                            child: Visibility(
                              visible: questionIndex != 0,
                              //在第一题不出现“上一题”的按钮
                              child: MyButton(
                                buttonLabel: ' 上一题 ',
                                onPressed: onBackButtonPressed,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50 * MediaQSize.heightRefScale,
                            child: Visibility(
                              visible: questionIndex != numberOfQuestions - 1,
                              child: MyButton(
                                buttonLabel: ' 下一题 ',
                                //前提是完成本题后 才能下一步

                                onPressed: userHasFinishedCurrentQuestion
                                    ? onNextButtonPressed
                                    : null,
                              ),
                            ),
                          ),
                          //完成设计最后一题 应该出现“提交”而不是下一步
                          SizedBox(
                            height: 50 * MediaQSize.heightRefScale,
                            child: Visibility(
                              visible: questionIndex == numberOfQuestions - 1,
                              child: MyButton(
                                buttonLabel: ' 提  交 ',
                                onPressed: userHasFinishedCurrentQuestion
                                    ? onSummitButtonPressed
                                    : null,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                //距离card右边界的间距
                SizedBox(
                  width: 11 * MediaQSize.widthRefScale,
                ),
              ],
            )),
      ],
    );
  }

  Widget TEQWidget(BuildContext context) {
    int numOfTEQ = 6;
    double currentPosition = questionIndex.toDouble(); //用于进度指引
    return ListView(
        // height: MediaQSize.thisDsize.height * 0.8,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0) *
                        MediaQSize.heightRefScale,
                child: Text(
                  "第 ${questionIndex + 1} 题 / 共 $numOfTEQ 题",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25 * MediaQSize.heightRefScale,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue1, //黑色
                  ),
                ),
              ),

              //用padding+card显示题目
              SizedBox(
                child: Card(
                    margin: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10, bottom: 30) *
                        MediaQSize.heightRefScale,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //进度状态提示小圆圈
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: MediaQSize.thisDsize.height * 0.6, //固定下大小
                            child: Padding(
                              padding: const EdgeInsets.all(5.0) *
                                  MediaQSize.heightRefScale,
                              child: DotsIndicator(
                                mainAxisSize: MainAxisSize.max, //扩大圈圈间距
                                dotsCount: numberOfQuestions,
                                axis: Axis.vertical,
                                position:
                                    currentPosition, //questionIndex.toDouble();
                                onTap: (pos) {
                                  int posint = pos.toInt();
                                  lastindex = max(questionIndex, lastindex);
                                  //debug用的
                                  // print("当前题号questionIndex: $questionIndex");
                                  // print("点到posint: $posint");
                                  // print("最后lastindex: $lastindex");
                                  //逻辑：只有回答过的记录可以点击进度球回去查看
                                  if (posint <= lastindex) {
                                    setState(() => questionIndex = posint);
                                  } else {
                                    setState(() => currentPosition =
                                        questionIndex.toDouble());
                                  }
                                },
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                decorator: DotsDecorator(
                                  size: const Size.square(18) *
                                      MediaQSize.heightRefScale,
                                  activeSize: const Size(25, 25) *
                                      MediaQSize.heightRefScale,
                                  activeColor: AppColors.bule3,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //纵隔间距
                        SizedBox(
                          width: 20 * MediaQSize.widthRefScale,
                        ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            //字数过多溢出的问题 通过指定宽度解决了
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15 * MediaQSize.heightRefScale,
                                    bottom: 15 * MediaQSize.heightRefScale),
                                child: Text(
                                  currentQuestion.questiontext,
                                  style: TextStyle(
                                      fontSize: 25 * MediaQSize.heightRefScale,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Divider(thickness: 5),

                              TEQbody(context, questionIndex),

                              const Divider(thickness: 5),
                              const SizedBox(
                                height: 100,
                              ),

                              //上一题 下一题
                              OverflowBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(
                                      width: 2 * MediaQSize.widthRefScale), //对中

                                  SizedBox(
                                    height: 50,
                                    child: Visibility(
                                      visible: questionIndex != 0,
                                      //在第一题不出现“上一题”的按钮
                                      child: MyButton(
                                        buttonLabel: ' 上一题 ',
                                        onPressed: onBackButtonPressed,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Visibility(
                                      visible: questionIndex !=
                                          numberOfQuestions - 1,
                                      child: MyButton(
                                        buttonLabel: ' 下一题 ',
                                        //前提是完成本题后 才能下一步

                                        onPressed:
                                            userHasFinishedCurrentQuestion
                                                ? onNextButtonPressed
                                                : null,
                                      ),
                                    ),
                                  ),
                                  //完成设计最后一题 应该出现“提交”而不是下一步
                                  SizedBox(
                                    height: 50,
                                    child: Visibility(
                                      visible: questionIndex ==
                                          numberOfQuestions - 1,
                                      child: MyButton(
                                        buttonLabel: ' 提  交 ',
                                        onPressed:
                                            userHasFinishedCurrentQuestion
                                                ? onSummitButtonPressed
                                                : null,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //下面空间
                              SizedBox(
                                height: 20 * MediaQSize.widthRefScale,
                              )
                            ],
                          ),
                        ),
                        //距离card右边界的间距
                        SizedBox(
                          width: 20 * MediaQSize.widthRefScale,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ]);
  }

//把题号也传入
  Widget TEQbody(BuildContext context, int questionIndex) {
    //     String currentOptionsleftStr = currentOptionsleft.optiontext;
    // String currentOptionsrightStr = currentOptionsright.optiontext;
    if (questionIndex != 5) {
      return RadioTileOptions(
        activeColor: AppColors.blue1, //选中的按钮
        labelStyle: TextStyle(fontSize: 25 * MediaQSize.heightRefScale), //按键字体
        labels: currentQuestion.answers
            .map((answer) => answer.optiontext)
            .toList(), //label是选项文本
        ifChange: (_, answerIndex) => setState(() {
          chosenOptionOrdinalIndexs[questionIndex] = answerIndex; //选项的自然顺序
        }),
        //进入下一题之前清空所选的记忆
        picked: !userHasFinishedCurrentQuestion
            ? ""
            : currentQuestion
                .answers[chosenOptionOrdinalIndexs[questionIndex]].optiontext,
      );
    } else {
      return Padding(
        padding:
            const EdgeInsets.fromLTRB(5, 70, 5, 30) * MediaQSize.heightRefScale,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //不同题 依托currentOptionsleft  展示最高和最低程度
                Text(currentOptionsleft.optiontext,
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
                Text(currentOptionsright.optiontext,
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
              ],
            ),
            Slider0_10(
              usermax: 6,
              usermin: 0,
              userdivisions: 6,
              isSlideDiscrete: true, //选择连续滑块，
              postSliderValue: chosenOptionOrdinalIndexs[questionIndex],

              slideOnChange: (currentSliderValue) => setState(() {
                chosenOptionOrdinalIndexs[questionIndex] = currentSliderValue
                    .toInt(); //获取slide0-10中的当前值,存入chosenSliderValues
              }),
            ),
          ],
        ),
      );

      // const SizedBox(
      //   height: 40,
      // );
    }
  }

  Widget PSQIWidget(BuildContext context) {
    {
      double currentPosition = questionIndex.toDouble(); //用于进度指引
      print('进入PSQI的build');
      String HeadStr = getPsqiHeadStr(questionIndex);
      // print(Headstr);
      //时刻选择题
      if (questionIndex == 0 || questionIndex == 2 || questionIndex == 3) {
        return ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0) *
                      MediaQSize.heightRefScale,
              child: Text(
                "第  $HeadStr 题 / 共 10 大题",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25 * MediaQSize.heightRefScale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue1, //黑色
                ),
              ),
            ),
            //用padding+card显示题目
            Card(
                margin: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 10, bottom: 30) *
                    MediaQSize.heightRefScale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //进度状态提示小圆圈
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            EdgeInsets.all(5.0 * MediaQSize.heightRefScale),
                        child: DotsIndicator(
                          mainAxisSize: MainAxisSize.max, //扩大圈圈间距

                          dotsCount: numberOfQuestions,
                          axis: Axis.vertical,
                          position: currentPosition, //questionIndex.toDouble();
                          onTap: (pos) {
                            int posint = pos.toInt();
                            lastindex = max(questionIndex, lastindex);
                            // debug用的
                            // print("当前题号questionIndex: $questionIndex");
                            // print("点到posint: $posint");
                            // print("最后lastindex: $lastindex");
                            // 逻辑：只有回答过的记录可以点击进度球回去查看
                            if (posint <= lastindex) {
                              setState(() => questionIndex = posint);
                            } else {
                              setState(() =>
                                  currentPosition = questionIndex.toDouble());
                            }
                          },
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          decorator: DotsDecorator(
                            size: const Size.square(18) *
                                MediaQSize.heightRefScale,
                            activeSize:
                                const Size(25, 25) * MediaQSize.heightRefScale,
                            activeColor: AppColors.bule3,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
                    //纵隔间距
                    SizedBox(
                      width: 10 * MediaQSize.widthRefScale,
                    ),

                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, right: 5) *
                                      MediaQSize.heightRefScale),
                          Text(
                            currentQuestion.questiontext,
                            style: TextStyle(
                                fontSize: 25 * MediaQSize.heightRefScale,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(thickness: 5),
                          const SizedBox(
                            height: 40,
                          ),

                          //时刻选择
                          Padding(
                            padding: const EdgeInsets.only(right: 50) *
                                MediaQSize.heightRefScale,
                            child: MyTimePicker(
                              psqiAnsStruct: psqiAnsStruct,
                              // typeoftimeforset: 'bedtime',
                              inttypeoftimeforset: questionIndex,
                              ifTimeChange: (index) {
                                setState(() {
                                  chosenOptionOrdinalIndexs[index] = 0;
                                });
                                //使用时间模块的 按钮的自然顺序列表是无效的，用0占个位 参数从widget中反传
                              },
                            ),
                          ),

                          const SizedBox(
                            height: 100,
                          ),
                          //上一题下一题
                          OverflowBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(width: 2 * MediaQSize.widthRefScale),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible: questionIndex != 0,
                                  //在第一题不出现“上一题”的按钮
                                  child: MyButton(
                                    buttonLabel: ' 上一题 ',
                                    onPressed: onBackButtonPressed,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible:
                                      questionIndex != numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 下一题 ',
                                    //前提是完成本题后 才能下一步
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onNextButtonPressed
                                        : null,
                                  ),
                                ),
                              ),
                              //完成设计最后一题 应该出现“提交”而不是下一步
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible:
                                      questionIndex == numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 提  交 ',
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onSummitButtonPressed
                                        : null,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        );
      }

      //其他一般选择题 (在第10题前)
      else if (questionIndex != 18) {
        return ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0) *
                      MediaQSize.heightRefScale,
              child: Text(
                "第  $HeadStr" " 题 / 共 10 大题",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25 * MediaQSize.heightRefScale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue1, //黑色
                ),
              ),
            ),
            //用padding+card显示题目

            Card(
                margin: const EdgeInsets.all(10.0) * MediaQSize.heightRefScale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //进度状态提示小圆圈
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0) *
                            MediaQSize.heightRefScale,
                        child: DotsIndicator(
                          mainAxisSize: MainAxisSize.max, //扩大圈圈间距

                          dotsCount: numberOfQuestions,
                          axis: Axis.vertical,
                          position: currentPosition, //questionIndex.toDouble();
                          onTap: (pos) {
                            int posint = pos.toInt();
                            lastindex = max(questionIndex, lastindex);
                            // debug用的
                            // print("当前题号questionIndex: $questionIndex");
                            // print("点到posint: $posint");
                            // print("最后lastindex: $lastindex");
                            // 逻辑：只有回答过的记录可以点击进度球回去查看
                            if (posint <= lastindex) {
                              setState(() => questionIndex = posint);
                            } else {
                              setState(() =>
                                  currentPosition = questionIndex.toDouble());
                            }
                          },
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          decorator: DotsDecorator(
                            size: const Size.square(18) *
                                MediaQSize.heightRefScale,
                            activeSize:
                                const Size(25, 25) * MediaQSize.heightRefScale,
                            activeColor: AppColors.bule3,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
                    //纵隔间距
                    SizedBox(
                      width: 10 * MediaQSize.widthRefScale,
                    ),

                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Text(
                            currentQuestion.questiontext, //
                            style: TextStyle(
                                fontSize: 25 * MediaQSize.heightRefScale,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(thickness: 5),
                          const SizedBox(
                            height: 5,
                          ),
                          //PSQI的选项
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RadioTileOptions(
                              activeColor: AppColors.blue1, //选中的按钮
                              labelStyle: TextStyle(
                                  fontSize:
                                      25 * MediaQSize.heightRefScale), //按键字体
                              labels: currentQuestion.answers
                                  .map((answer) => answer.optiontext)
                                  .toList(), //label是选项文本的·list
                              //输入 string 和 int类
                              //返回一个void函数———重建更新答案
                              ifChange: (_, answerIndex) => setState(() {
                                print("进入radios组件的onChange");
                                chosenOptionOrdinalIndexs[questionIndex] =
                                    answerIndex; //把组件的选项的自然顺序 传回来存到chosenOptionOrdinalIndexs中
                              }),
                              //进入下一题之前清空所选的记忆
                              picked: !userHasFinishedCurrentQuestion
                                  ? ""
                                  : currentQuestion
                                      .answers[chosenOptionOrdinalIndexs[
                                          questionIndex]]
                                      .optiontext,
                            ),
                          ),
                          // const Divider(thickness: 5),
                          const SizedBox(
                            height: 50,
                          ),
                          //上一题下一题
                          OverflowBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(width: 2 * MediaQSize.widthRefScale),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible: questionIndex != 0,
                                  //在第一题不出现“上一题”的按钮
                                  child: MyButton(
                                    buttonLabel: ' 上一题 ',
                                    onPressed: onBackButtonPressed,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible:
                                      questionIndex != numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 下一题 ',
                                    //前提是完成本题后 才能下一步

                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onNextButtonPressed
                                        : null,
                                  ),
                                ),
                              ),
                              //完成设计最后一题 应该出现“提交”而不是下一步
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible:
                                      questionIndex == numberOfQuestions - 1,
                                  child: MyButton(
                                    buttonLabel: ' 提  交 ',
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onSummitButtonPressed
                                        : null,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    //距离card右边界的间距

                    SizedBox(
                      width: 20 * MediaQSize.widthRefScale,
                    ),
                  ],
                )),
          ],
        );
      }
      //后10题 他人评价题 不计入计算分
      else
      //if (questionIndex == 18) //舍友有无？
      {
        return ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                "第  $HeadStr" " 题 / 共 10 大题",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25 * MediaQSize.heightRefScale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue1, //黑色
                ),
              ),
            ),
            //用padding+card显示题目
            Card(
                margin: const EdgeInsets.all(10.0) * MediaQSize.heightRefScale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //进度状态提示小圆圈
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0) *
                            MediaQSize.heightRefScale,
                        child: DotsIndicator(
                          mainAxisSize: MainAxisSize.max, //扩大圈圈间距

                          dotsCount: numberOfQuestions,
                          axis: Axis.vertical,
                          position: currentPosition, //questionIndex.toDouble();
                          onTap: (pos) {
                            int posint = pos.toInt();
                            lastindex = max(questionIndex, lastindex);
                            if (posint <= lastindex) {
                              setState(() => questionIndex = posint);
                            } else {
                              setState(() =>
                                  currentPosition = questionIndex.toDouble());
                            }
                          },
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          decorator: DotsDecorator(
                            size: const Size.square(18) *
                                MediaQSize.heightRefScale,
                            activeSize:
                                const Size(25, 25) * MediaQSize.heightRefScale,
                            activeColor: AppColors.bule3,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
                    //纵隔间距
                    SizedBox(
                      width: 10 * MediaQSize.widthRefScale,
                    ),

                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Text(
                            currentQuestion.questiontext, //
                            style: TextStyle(
                                fontSize: 25 * MediaQSize.heightRefScale,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(thickness: 5),
                          const SizedBox(
                            height: 5,
                          ),
                          //PSQI的选项
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RadioTileOptions(
                              activeColor: AppColors.blue1, //选中的按钮
                              labelStyle: TextStyle(
                                  fontSize:
                                      25 * MediaQSize.heightRefScale), //按键字体
                              labels: currentQuestion.answers
                                  .map((answer) => answer.optiontext)
                                  .toList(), //label是选项文本的·list
                              //输入 string 和 int类
                              //返回一个void函数———重建更新答案
                              ifChange: (_, answerIndex) => setState(() {
                                print("进入radios组件的onChange");
                                chosenOptionOrdinalIndexs[questionIndex] =
                                    answerIndex; //把组件的选项的自然顺序 传回来存到chosenOptionOrdinalIndexs中
                              }),
                              //进入下一题之前清空所选的记忆
                              picked: !userHasFinishedCurrentQuestion
                                  ? ""
                                  : currentQuestion
                                      .answers[chosenOptionOrdinalIndexs[
                                          questionIndex]]
                                      .optiontext,
                            ),
                          ),
                          // const Divider(thickness: 5),
                          const SizedBox(
                            height: 50,
                          ),
                          //上一题下一题
                          OverflowBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(width: 2 * MediaQSize.widthRefScale),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible: questionIndex != 0,
                                  //在第一题不出现“上一题”的按钮
                                  child: MyButton(
                                    buttonLabel: ' 上一题 ',
                                    onPressed: onBackButtonPressed,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible:
                                      (questionIndex != numberOfQuestions - 1) &
                                          (chosenOptionOrdinalIndexs[18] != 0),
                                  child: MyButton(
                                    buttonLabel: ' 下一题 ',
                                    //前提是完成本题后 才能下一步

                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onNextButtonPressed
                                        : null,
                                  ),
                                ),
                              ),
                              //完成设计最后一题 应该出现“提交”而不是下一步
                              SizedBox(
                                height: 50,
                                child: Visibility(
                                  visible: (questionIndex ==
                                          numberOfQuestions - 1) ||
                                      (chosenOptionOrdinalIndexs[18] == 0),
                                  child: MyButton(
                                    buttonLabel: ' 提  交 ',
                                    onPressed: userHasFinishedCurrentQuestion
                                        ? onSummitButtonPressed
                                        : null,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    //距离card右边界的间距

                    SizedBox(
                      width: 20 * MediaQSize.widthRefScale,
                    ),
                  ],
                )),
          ],
        );
      }
    }
  }

//用于生成QRcode里面的索引序列
  List<num> qrlistRawChoicesIdx() {
    switch (widget.chosenquiz.quizName) {
      case "耳鸣致残量表（THI）":
      case "耳鸣评价量表（TEQ）":
      case "匹兹堡睡眠质量指数量表（PSQI）":
        return chosenOptionOrdinalIndexs; //每题所选选项的索引号（第一个选项设为0）
      case "耳鸣功能指数量表（TFI）":
        List<num> lis = [];
        for (var element in chosenSliderValues) {
          lis.add(element.toInt()); //把TFI里面的slide数值化为int存储
        }

        return lis;
      default:
        return [];
    }
  }

//直接改变dart内的变量：StoreQuizsTodate.xxxList
  updateStore() {
    //定义待写入QR的数列
    List<num> ListToWr = [];
    ListToWr.add(widget.chosenquiz.quizusersResult.userrawscorerd);

    for (var element in widget.chosenquiz.quizusersResult.userAspectScores) {
      ListToWr.add(element.aspectScore..toStringAsFixed(1)); //每个子项
    }

    ListToWr.addAll(qrlistRawChoicesIdx()); //写入原始指引

    // developer.log("最新作答的一份量表的数据：$ListToWr");

    switch (widget.chosenquiz.quizName) {
      case "耳鸣致残量表（THI）":
        {
          if ((QuizsJust5.THILists == null)) {
            QuizsJust5.THILists = [widget.chosenquiz];
          } else {
            QuizsJust5.THILists?.add(widget.chosenquiz);
          }

          StoreQuizs.THIqrNumData = ListToWr;
          // print('写入公共list${StoreQuizs.THIList}');

          int start = StoreQuizs.strdata.indexOf('THI,') + 4;
          int end = StoreQuizs.strdata.indexOf(";", start); //截至这里之前 （含首不含尾）
          print([start, end]);
          StoreQuizs.strdata = StoreQuizs.strdata
              .replaceRange(start, end, ListToWr.join(',')); // 范围替换 从0-3 含0不含3

          developer.log(StoreQuizs.strdata);
        }
        break;
      case "耳鸣评价量表（TEQ）":
        {
          if ((QuizsJust5.TEQLists == null)) {
            QuizsJust5.TEQLists = [widget.chosenquiz];
          } else {
            QuizsJust5.TEQLists?.add(widget.chosenquiz);
          }
          StoreQuizs.TEQqrNumData = ListToWr;
          // print('写入公共list${StoreQuizs.TEQList}');

          int start = StoreQuizs.strdata.indexOf('TEQ,') + 4;
          int end = StoreQuizs.strdata.indexOf(";", start); //截至这里之前 （含首不含尾）
          print([start, end]);
          StoreQuizs.strdata = StoreQuizs.strdata
              .replaceRange(start, end, ListToWr.join(',')); // 范围替换 从0-3 含0不含3
          developer.log("QR数据:${StoreQuizs.strdata}");
        }
        break;

      case "耳鸣功能指数量表（TFI）":
        {
          if ((QuizsJust5.TFILists == null)) {
            QuizsJust5.TFILists = [widget.chosenquiz];
          } else {
            QuizsJust5.TFILists?.add(widget.chosenquiz);
          }
          StoreQuizs.TFIqrNumData = ListToWr;
          // print('写入公共list${StoreQuizs.TFIList}');

          int start = StoreQuizs.strdata.indexOf('TFI,') + 4;
          int end = StoreQuizs.strdata.indexOf(";", start); //截至这里之前 （含首不含尾）
          print([start, end]);
          StoreQuizs.strdata = StoreQuizs.strdata
              .replaceRange(start, end, ListToWr.join(',')); // 范围替换 从0-3 含0不含3
          developer.log("QR数据:${StoreQuizs.strdata}");
        }
        break;
      case "匹兹堡睡眠质量指数量表（PSQI）":
        {
          if ((QuizsJust5.PSQILists == null)) {
            QuizsJust5.PSQILists = [widget.chosenquiz];
          } else {
            QuizsJust5.PSQILists?.add(widget.chosenquiz);
          }
          StoreQuizs.PSQIqrNumData = ListToWr;
          // print('写入公共list${StoreQuizs.PSQIList}');

          int start = StoreQuizs.strdata.indexOf('PSQI,') + 5;
          int end = StoreQuizs.strdata.indexOf(";", start); //截至这里之前 （含首不含尾）
          print([start, end]);
          StoreQuizs.strdata = StoreQuizs.strdata
              .replaceRange(start, end, ListToWr.join(',')); // 范围替换 从0-3 含0不含3

          developer.log("QR数据:${StoreQuizs.strdata}");
        }
        break;
      case "视觉模拟量表（VAS）":
        {
          if ((QuizsJust5.VASLists == null)) {
            QuizsJust5.VASLists = [widget.chosenquiz];
          } else {
            QuizsJust5.VASLists?.add(widget.chosenquiz);
          }
          //VAS只写两个分量
          StoreQuizs.VASqrNumData = [
            widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore,
            widget.chosenquiz.quizusersResult.userAspectScores[1].aspectScore
          ]; //仅仅2项
          ListToWr = StoreQuizs.VASqrNumData!;

          // print('写入公共${StoreQuizs.VASList}');

          int start = StoreQuizs.strdata.indexOf('VAS,') + 4;
          int end = StoreQuizs.strdata.indexOf(";", start); //截至这里之前 （含首不含尾）
          print([start, end]);
          // 例如 范围替换 从0-3 含0不含3
          // print("ListToWr.join之后：${ListToWr.join(',')}");
          StoreQuizs.strdata = StoreQuizs.strdata
              .replaceRange(start, end, ListToWr.join(',')); // 范围替换 从0-3 含0不含3

          developer.log("QR数据:${StoreQuizs.strdata}");
        }
        break;
    }

    //统一将整个量表压入栈 为本地数据做准备
    if ((StoreQuizs.quizInfoTotalRcnList == null)) {
      StoreQuizs.quizInfoTotalRcnList = [widget.chosenquiz];
    } else {
      StoreQuizs.quizInfoTotalRcnList?.add(widget.chosenquiz);
    }
    developer
        .log('量表完整历史记录数${StoreQuizs.quizInfoTotalRcnList?.length}'); //debug
  }

  //按“下一题”按钮后的操作
  void onNextButtonPressed() {
    setState(() {
      questionIndex++; //驱动变化的引擎
    });
  }

  //按“上一题”按钮后的操作
  void onBackButtonPressed() {
    if (questionIndex > 0) {
      setState(() {
        questionIndex--;
      });
    }
  }

  //按“提交”按钮后的操作
  void onSummitButtonPressed() {
    ///最后一题完成后的跳转——>结果界面
    ///传入 问卷类
    // developer.log(widget.chosenquiz.quizName);

    //按钮类 调用cal_ResultRankstr 返回程度解释
    if ((widget.chosenquiz.quizName == "耳鸣致残量表（THI）") ||
        (widget.chosenquiz.quizName == "匹兹堡睡眠质量指数量表（PSQI）")) {
      //写入问卷类保存后，也是作为传递
      calTHIorPSQIresult(); //调用计算结果的函数
      // print( "调用后，外部FAspectScore:${widget.chosenquiz.quizusersResult.userAspectScores[0].aspectScore}");//debug
      // print("等级计算类别：${widget.chosenquiz.quizusersResult?.userrankrd}");

    } else if (widget.chosenquiz.quizName == "耳鸣功能指数量表（TFI）") {
      //写入问卷类保存后，也是作为传递
      calslideTFIresult(); //调用计算结果的 返回结果等级的函数
      // print("等级计算类别：${widget.chosenquiz.quizusersResult?.userrankrd}");
    } else if (widget.chosenquiz.quizName == "视觉模拟量表（VAS）") {
      calVASresult();
    } else if (widget.chosenquiz.quizName == "耳鸣评价量表（TEQ）") {
      calTEQresult();
    } else {
      developer.log("无");
    }

    // //统一存入总分
    // widget.chosenquiz.quizusersResult.userrawscorerd = finalResult; //写入最后的
    // developer.log("总分：$finalResult");
    // //统一存入原始序号
    // widget.chosenquiz.quizusersResult.userrawchoiceIdx = qrlistRawChoicesIdx();
    // developer.log(
    //     "所选选项索引：${widget.chosenquiz.quizusersResult.userrawchoiceIdx}"); //debug
    //统一改变总目录下的strdata 为QR码做准备
    updateStore();

    // print(StoreQuizsTodate()); //debug

    //pushReplacement直接替换掉，不返回故而不是push
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          chosenquiz: widget.chosenquiz,
        ),
      ),
    );
  }
}
