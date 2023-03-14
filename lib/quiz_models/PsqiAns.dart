import 'package:flutter/material.dart';

class PsqiAnsStruct {
  // DateTime bedtime = TimeOfDay.now() as DateTime;
  TimeOfDay bedtime;
  TimeOfDay offbedtime;
  TimeOfDay actualsleeptime;
  Duration diffbedtimedate;

  PsqiAnsStruct(
      {this.bedtime = const TimeOfDay(hour: 23, minute: 0),
      this.offbedtime = const TimeOfDay(hour: 7, minute: 0),
      this.actualsleeptime = const TimeOfDay(hour: 7, minute: 0),
      this.diffbedtimedate = const Duration(hours: 0)}//床上时间，//计算差值 可以使用difference 和 inminute
      
      );
}
