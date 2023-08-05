import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configs/app_colors.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/PsqiAns.dart';

class ClkCuperPicker extends StatefulWidget {
  final int questionIndex;
  void Function(int index) ifTimeChange;
  PSQIRelatedStruct psqiAnsStruct; //直接改变类中变量

  ClkCuperPicker({
    super.key,
    required this.questionIndex,
    // required this.onTimeSelected,
    required this.psqiAnsStruct,
    required this.ifTimeChange,
  });

  @override
  _ClkCuperPickerState createState() => _ClkCuperPickerState();
}

class _ClkCuperPickerState extends State<ClkCuperPicker> {
  late TimeOfDay time; // = TimeOfDay.now()
  late Future<bool> has; //用于显示异步加载的flag

  // TimeOfDay time = TimeOfDay.now();
  // TimeOfDay time2 = TimeOfDay.now();
  // TimeOfDay time3 = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    print("进入timepicker的初始化");
    if (widget.questionIndex == 0) {
      time = widget.psqiAnsStruct.bedtime;
      // ??const TimeOfDay(hour: 23, minute: 0); //初始化
    } else if (widget.questionIndex == 2) {
      time = widget.psqiAnsStruct.offbedtime;
      // ??          const TimeOfDay(hour: 7, minute: 0); //初始化
    } else if (widget.questionIndex == 3) {
      time = widget.psqiAnsStruct.actualsleeptime;
      // time = const TimeOfDay(hour: 7, minute: 0); //初始化
    }
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay? picked;

    if (widget.questionIndex == 0) {
      time = widget.psqiAnsStruct.bedtime;
      // ??const TimeOfDay(hour: 23, minute: 0); //初始化
    } else if (widget.questionIndex == 2) {
      time = widget.psqiAnsStruct.offbedtime;
      // time= const TimeOfDay(hour: 7, minute: 0); //初始化
    } else if (widget.questionIndex == 3) {
      time = widget.psqiAnsStruct.actualsleeptime;
      // time = const TimeOfDay(hour: 7, minute: 0); //初始化
    }

    return Column(
      children: [
        Text(
          '${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
              fontSize: 24 * MediaQSize.widthRefScale,
              color: AppColors.pPurple,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18 * MediaQSize.heightRefScale,
                letterSpacing: 8 * MediaQSize.widthRefScale,
              ),
              // pickerTextStyle: const TextStyle(color: Colors.pink, fontSize: 18),
            ),
          ),
          child: CupertinoDatePicker(
            use24hFormat: true,
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(0, 1, 1, time.hour, time.minute),
            onDateTimeChanged: (DateTime newDateTime) {
              picked =
                  TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
              if (picked != null) {
                setState(() {
                  time = picked!;
                });
                if (widget.questionIndex == 0) {
                  widget.psqiAnsStruct.bedtime = time;
                } else if (widget.questionIndex == 2) {
                  widget.psqiAnsStruct.offbedtime = time;
                } else if (widget.questionIndex == 3) {
                  widget.psqiAnsStruct.actualsleeptime = time;
                }
                widget.ifTimeChange(widget.questionIndex);
              }
            },
          ),
        )),
      ],
    );
  }
}
