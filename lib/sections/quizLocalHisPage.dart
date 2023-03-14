//以下为文件7-quizLocalHisPage.dart中的内容：
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/quiz_models/QuizInfo.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,

        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
        title: Text(
          '量表历史记录',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
        ),
      ),
      body: ListShowbody(), //构造子页面1
    );
  }
}

// 导入本地模拟的数据，循环生成列表
//改成只显示一个
class ListShowbody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<QuizInfo>? targetList = StoreQuizs.quizInfoTotalRcnList; //不记录完全历史了

    List<QuizInfo?> targetList2 = [
      QuizsJust5.THILists?.last,
      QuizsJust5.VASLists?.last,
      QuizsJust5.TFILists?.last,
      QuizsJust5.TEQLists?.last,
      QuizsJust5.PSQILists?.last,
    ];

    getAspectsStr(int index) {
      var obj = targetList2[index]; //只在有结果的时候调用
      //把各个方面的名称+分数 串联起来
      String zixiang = '';
      List listAspectName = []..length =
          obj!.quizusersResult.userAspectScores.length;
      List listAspectScore = []..length =
          obj.quizusersResult.userAspectScores.length;
      List listAspectsData = []..length =
          obj.quizusersResult.userAspectScores.length;
      for (int i = 0; i < obj.quizusersResult.userAspectScores.length; i++) {
        listAspectName[i] = obj.quizusersResult.userAspectScores[i].aspectName;
        listAspectScore[i] = obj.quizusersResult.userAspectScores[i].aspectScore
            .toStringAsFixed(0); //四舍五入 保留0位小数
        //串起来
        listAspectsData[i] = "${listAspectName[i]}：${listAspectScore[i]}分\n";
        zixiang = zixiang + listAspectsData[i];
      }
      log('子项得分\n：$zixiang');
      return zixiang;
    }

    titleContentNotNull(int index) {
      return (targetList2[index]!.quizName == "视觉模拟量表（VAS）")
          ? Text(
              '声响程度：得分：${targetList2[index]?.quizusersResult.userAspectScores[0].aspectScore.toStringAsFixed(0)}分，评级：${targetList2[index]?.quizusersResult.userAspectScores[0].aspectRank_VAS}\n烦躁程度：得分：${targetList2[index]?.quizusersResult.userAspectScores[1].aspectScore.toStringAsFixed(0)}分，评级：${targetList2[index]?.quizusersResult.userAspectScores[1].aspectRank_VAS}\n',
              style: TextStyle(fontSize: 15 * MediaQSize.heightRefScale))
          : Text(
              '得分：${targetList2[index]?.quizusersResult.userrawscorerd.toStringAsFixed(0)}分， 评级：${targetList2[index]?.quizusersResult.userrankrd}',
              style: TextStyle(fontSize: 15 * MediaQSize.heightRefScale));
    }

    subtitleContentNotNull(int index) {
      return (targetList2[index]!.quizName == "视觉模拟量表（VAS）")
          ? null
          : Text('子项得分：\n${getAspectsStr(index)}',
              style: TextStyle(fontSize: 15 * MediaQSize.heightRefScale));
    }

    Widget ListtileModel(String name, int index) {
      return Column(
        children: [
          ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
              //使用visualDensity属性来调整ListTile的高度，正数会增加高度，负数会减少高度，最大值和最小值分别是4和-4
              leading: SizedBox(
                  width: 260 * MediaQSize.widthRefScale,
                  child: Text(name,
                      style: TextStyle(
                          wordSpacing: 2,
                          fontWeight: FontWeight.w500,
                          fontSize: 16 * MediaQSize.heightRefScale))),
              title: targetList2[index] == null
                  ? Text(
                      '暂无记录',
                      style:
                          TextStyle(fontSize: 15 * MediaQSize.heightRefScale),
                    )
                  : titleContentNotNull(index),
              subtitle: targetList2[index] == null
                  ? null
                  : subtitleContentNotNull(index)),
          const Divider(height: 2.0, color: Colors.grey)
        ],
      );
    }

    return ListView(
      children: [
        ListtileModel('耳鸣致残量表（THI）', 0),
        ListtileModel('视觉模拟量表（VAS）', 1),
        ListtileModel('耳鸣功能指数量表（TFI）', 2),
        ListtileModel('耳鸣评价量表（TEQ）', 3),
        ListtileModel('匹兹堡睡眠质量指数量表（PSQI）', 4),
      ],
    );

    // return (targetList == null) || (targetList == [])
    //     ? Center(
    //         child: Text(
    //         '暂无记录',
    //         style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale),
    //       ))
    //     : ListView.separated(
    //         itemCount: targetList.length,
    //         separatorBuilder: (BuildContext context, int index) =>
    //             const Divider(height: 2.0, color: Colors.grey),
    //         itemBuilder: (BuildContext context, int index) {
    //           var obj = targetList[index];
    //           //把各个方面的名称+分数 串联起来
    //           String zixiang = '';
    //           List listAspectName = []..length =
    //               obj.quizusersResult.userAspectScores.length;
    //           List listAspectScore = []..length =
    //               obj.quizusersResult.userAspectScores.length;
    //           List listAspectsData = []..length =
    //               obj.quizusersResult.userAspectScores.length;
    //           for (int i = 0;
    //               i < obj.quizusersResult.userAspectScores.length;
    //               i++) {
    //             listAspectName[i] =
    //                 obj.quizusersResult.userAspectScores[i].aspectName;
    //             listAspectScore[i] = obj
    //                 .quizusersResult.userAspectScores[i].aspectScore
    //                 .toStringAsFixed(0); //四舍五入 保留0位小数
    //             //串起来
    //             listAspectsData[i] =
    //                 "${listAspectName[i]}：${listAspectScore[i]}分\n";
    //             zixiang = zixiang + listAspectsData[i];
    //           }
    //           // print('子项得分\n：$zixiang');
    //           return ListTile(
    //             leading: SizedBox(
    //                 width: 220 * MediaQSize.widthRefScale,
    //                 child: Text(obj.quizName,
    //                     style: TextStyle(
    //                         wordSpacing: 2,
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: 16 * MediaQSize.heightRefScale))),
    //             title: obj.quizName != "视觉模拟量表（VAS）"
    //                 ? Text(
    //                     '得分：${obj.quizusersResult.userrawscorerd.toStringAsFixed(0)}分， 评级：${obj.quizusersResult.userrankrd}',
    //                     style:
    //                         TextStyle(fontSize: 15 * MediaQSize.heightRefScale))
    //                 : Text(
    //                     '声响程度：得分：${obj.quizusersResult.userAspectScores[0].aspectScore.toStringAsFixed(0)}分，评级：${obj.quizusersResult.userAspectScores[0].aspectRank_VAS}\n烦躁程度：得分：${obj.quizusersResult.userAspectScores[1].aspectScore.toStringAsFixed(0)}分，评级：${obj.quizusersResult.userAspectScores[1].aspectRank_VAS}',
    //                     style: TextStyle(
    //                         fontSize: 15 * MediaQSize.heightRefScale)),
    //             subtitle: obj.quizName != "视觉模拟量表（VAS）"
    //                 ? Text('子项得分：\n$zixiang',
    //                     style:
    //                         TextStyle(fontSize: 14 * MediaQSize.heightRefScale))
    //                 : null,
    //             trailing: Text(
    //               '${index + 1}',
    //               style: TextStyle(fontSize: 14 * MediaQSize.heightRefScale),
    //             ),
    //             // dense: true
    //           );
    //         },
    //       );
  }
}
