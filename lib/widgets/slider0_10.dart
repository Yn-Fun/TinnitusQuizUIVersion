import 'package:flutter/material.dart';

import '../configs/app_colors.dart';
import '../configs/media_QSize.dart';

class Slider0_10 extends StatefulWidget {
  final bool isSlideDiscrete;
  final double usermax;
  final double usermin;
  final int userdivisions;
  void Function(num)? slideOnChange;
  num? postSliderValue; //给TFI 回选的时候 能记住并展示之前的值
  bool?
      NotReset; //NotReset = false，则如果进入新的一题 则要清零【为TFI设计的】；若NotReset = 1，(VAS只有1题)则不重置

//输入 是否是离散滑块，默认是离散的
  Slider0_10(
      {super.key,
      this.isSlideDiscrete = true,
      this.usermax = 10,
      this.usermin = 0,
      this.userdivisions = 10,
      this.slideOnChange,
      this.postSliderValue,
      this.NotReset = false}); //默认有多题 所以要重置

  @override
  State<Slider0_10> createState() => _Slider0_10State();
}

class _Slider0_10State extends State<Slider0_10> {
  num currentSliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double currentSliderValue = 0;
    print("进入initstate了");
  }

  @override
  Widget build(BuildContext context) {
    currentSliderValue = widget.postSliderValue ?? currentSliderValue; //
    // print(        "进入slide0_10的Build，postSliderValue值： ${widget.postSliderValue}；"); //debug
    // print(        "进入slide0_10的Build，现在currentSliderValue值： $currentSliderValue"); //debug

    //离散
    //VAS量表仅1题不用重置，（NotReset == True）
    //TFI需要重置（NotReset == false）
    if (widget.isSlideDiscrete) {
      if ((widget.NotReset == false) & (widget.postSliderValue == null)) {
        currentSliderValue = 0; //如果进入新的一题 设为0
      }
      return Column(
        children: [
          SliderTheme(
            //外套一个slidertheme可以重写slider
            data: SliderThemeData(
              valueIndicatorTextStyle:
                  TextStyle(fontSize: 16 * MediaQSize.heightRefScale), //提示数字
              trackHeight: 10 * MediaQSize.heightRefScale,
              showValueIndicator: ShowValueIndicator.always, //从默认只有离散有 改为都显示
              tickMarkShape: RoundSliderTickMarkShape(
                  tickMarkRadius: 2 * MediaQSize.heightRefScale), //滑动轨迹上的小圆点
              activeTickMarkColor: Colors.white,
            ),
            child: Slider(
              mouseCursor: SystemMouseCursors.grab,
              thumbColor: AppColors.pPurple,
              activeColor: AppColors.pPurple,
              inactiveColor: AppColors.lightgrey,
              value: currentSliderValue.toDouble(),
              max: widget.usermax,
              min: widget.usermin,
              divisions: widget.userdivisions, //划分成多少段
              //离散标签 有division 才会有label
              label: currentSliderValue.round().toString(), //当前值标注
              onChanged: (double value) {
                setState(() {
                  currentSliderValue = value;
                  widget.slideOnChange!(
                      value); //获取slide0-10中的当前值,存入chosenSliderValues
                  print("进入slider组件的的onchanged,当前滑块值： $value"); //debug
                });
              },
              //加入之后可以点击0积分就有相应
              onChangeStart: (double value) {
                setState(() {
                  currentSliderValue = value;
                  widget.slideOnChange!(
                      value); //获取slide0-10中的当前值,存入chosenSliderValues
                  print("进入slider组件的的onchanged,当前滑块值： $value"); //debug
                });
              },
            ),
          ),
          SizedBox(
            height: 5 * MediaQSize.heightRefScale,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "当前值 / 最大值  =  ${currentSliderValue.toStringAsFixed(0)} / ${widget.usermax.toStringAsFixed(0)}",
                style: TextStyle(
                    fontSize: 18 * MediaQSize.heightRefScale,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              // Text(),
            ],
          )
        ],
      );
    }
    //连续值（现在都不用了）
    else {
      return Column(
        children: [
          SliderTheme(
              data: SliderThemeData(
                trackHeight: 10 * MediaQSize.heightRefScale,
                valueIndicatorTextStyle:
                    TextStyle(fontSize: 16 * MediaQSize.heightRefScale), //提示数字
                showValueIndicator: ShowValueIndicator.always, //从默认只有离散有 改为都显示
              ),
              child: Slider(
                value: currentSliderValue.toDouble(),
                max: widget.usermax,
                min: widget.usermin,
                //连续值没有label
                label: currentSliderValue.toStringAsFixed(2), //当前值标注

                onChanged: (double value) {
                  setState(() {
                    print("进入连续slide组件的onchanged"); //debug
                    currentSliderValue = value;
                    widget.slideOnChange!(
                        value); //获取slide0-10中的当前值,存入chosenSliderValues

                    print("当前滑块值： $value"); //debug
                  });
                },
              )),
          SizedBox(
            height: 40 * MediaQSize.heightRefScale,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "当前值/最大值  =  ${currentSliderValue.toStringAsFixed(1)} / ${widget.usermax.toStringAsFixed(1)}", //toStringAsPrecision有效数字
                style: TextStyle(fontSize: 23 * MediaQSize.heightRefScale),
              ),
              // Text(),
            ],
          )
        ],
      );
    }
  }
}
