import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/quiz_models/PsqiAns.dart';

import '../configs/media_QSize.dart';

class MyTimePicker extends StatefulWidget {
  PsqiAnsStruct psqiAnsStruct;
  int inttypeoftimeforset;
  void Function(int index) ifTimeChange;

  MyTimePicker({
    super.key,
    required this.inttypeoftimeforset,
    required this.psqiAnsStruct,
    required this.ifTimeChange,
  });

  @override
  _MyTimePickerState createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  late TimeOfDay time; // = TimeOfDay.now()

  @override
  void initState() {
    super.initState();
    print("进入timepicker的初始化");
    if (widget.inttypeoftimeforset == 0) {
      time = widget.psqiAnsStruct
          .bedtime; // ??const TimeOfDay(hour: 23, minute: 0); //初始化
    } else if (widget.inttypeoftimeforset == 2) {
      time = widget.psqiAnsStruct
          .offbedtime; // ??          const TimeOfDay(hour: 7, minute: 0); //初始化
    } else if (widget.inttypeoftimeforset == 3) {
      time = widget.psqiAnsStruct
          .actualsleeptime; //??          const TimeOfDay(hour: 7, minute: 0); //初始化
    }
  }

  //当前题是否已作答
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
      cancelText: "取消",
      helpText: "（默认24小时制）",
      confirmText: "确认",
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          //MediaQuery属于widget的子类
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true), //24小时制
          child: child!, //TODO
        );
      },
    );

    // int quertion3timeIndex = 0;
    if (picked != null) {
      //增加鲁棒性 可以点空白处退出去
      setState(() {
        time = picked;
      });
      if (widget.inttypeoftimeforset == 0) {
        widget.psqiAnsStruct.bedtime = time; //向类中里面写进去
        // quertion3timeIndex = 0; //第一题
      } else if (widget.inttypeoftimeforset == 2) {
        widget.psqiAnsStruct.offbedtime = time; //向类中里面写进去
        // quertion3timeIndex = 2; //第三题
      } else if (widget.inttypeoftimeforset == 3) {
        widget.psqiAnsStruct.actualsleeptime = time; //向类中里面写进去
        // quertion3timeIndex = 3; //第四题
      }
      widget.ifTimeChange(widget
          .inttypeoftimeforset); //将题号 返回给主函数 传回chosenOptionOrdinalIndexs用0替代null
    }
  }

  @override
  Widget build(BuildContext context) {
    print("进入timepicker的build");
    if (widget.inttypeoftimeforset == 0) {
      time = widget.psqiAnsStruct
          .bedtime; // ??const TimeOfDay(hour: 23, minute: 0); //初始化
    } else if (widget.inttypeoftimeforset == 2) {
      time = widget.psqiAnsStruct
          .offbedtime; // ??          const TimeOfDay(hour: 7, minute: 0); //初始化
    } else if (widget.inttypeoftimeforset == 3) {
      time = widget.psqiAnsStruct
          .actualsleeptime; //??          const TimeOfDay(hour: 7, minute: 0); //初始化
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '请点击下方按钮选定时间：',
            style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale),
          ),
          SizedBox(
            height: 20 * MediaQSize.heightRefScale,
          ),
          OutlinedButton.icon(
            label: Text(
              '当前值：$time',
              style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
            ),
            onPressed: () {
              _selectTime(context); //进入含有选时窗口的函数
            },
            icon: Icon(Icons.timelapse, size: 30 * MediaQSize.heightRefScale),
          ),
        ],
      ),
    );
  }
}
