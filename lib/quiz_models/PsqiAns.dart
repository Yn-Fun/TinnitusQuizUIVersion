import 'package:flutter/material.dart';

class PSQIRelatedStruct {
  // DateTime bedtime = TimeOfDay.now() as DateTime;
  TimeOfDay bedtime;
  TimeOfDay offbedtime;
  TimeOfDay actualsleeptime;
  Duration diffbedtimedate;

  PSQIRelatedStruct(
      {this.bedtime = const TimeOfDay(hour: 23, minute: 0),
      this.offbedtime = const TimeOfDay(hour: 7, minute: 0),
      this.actualsleeptime = const TimeOfDay(hour: 7, minute: 0),
      this.diffbedtimedate =
          const Duration(hours: 0)} //床上时间，//计算差值 可以使用difference 和 inminute

      );

  //输入 int：PSQI题号的自然顺序（小题）
  //输出 str：提取的有效题头标号
  static getPsqiHeadStr(int order) {
    //原来用于从顿号字符识别中读取题号
    String HeadStr = '';
    List strABCDE = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    int flag = 0;
    if (order >= 0 && order <= 3) {
      flag = 0;
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
}
