//经修后

import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/app_colors.dart';

import '../configs/media_QSize.dart';

class RadioTileOptions extends StatefulWidget {
  /// 选项文本 具有互异性.
  final List<String> labels;

  /// 指定要自动选取的单选按钮
  /// Specifies which Radio button to automatically pick.
  /// Every element must match a label.
  /// This is useful for clearing what is picked (set it to "").
  /// If this is non-null, then the user must handle updating this; otherwise, the state of the RadioButtonGroup won't change.
  final String picked;

  /// Specifies which buttons should be disabled.
  /// If this is non-null, no buttons will be disabled.
  /// The strings passed to this must match the labels.
  final List<String> disabled = [''];

  /// 当 值更改时调用。Called when the value of the RadioButtonGroup changes.
  final void Function(String label, int index) ifChange;

//TODO: void Function(String selected) onSelected
  /// Called when the user makes a selection.
  // final void Function(String selected) onSelected;

  /// The style to use for the labels.
  final TextStyle labelStyle;

  // /// Called when needed to build a RadioButtonGroup element.
  //TODO: itemBuilder
  // final Widget Function(RadioListTile radioButton, int index) itemBuilder;

  //RADIO BUTTON FIELDS
  /// The color to use when a Radio button is checked.
  final Color activeColor = Colors.blue;

  //SPACING STUFF
  /// Empty space in which to inset the RadioButtonGroup.
  final EdgeInsetsGeometry padding;

  /// Empty space surrounding the RadioButtonGroup.
  final EdgeInsetsGeometry margin;

  RadioTileOptions({
    super.key,
    required this.labels, //
    this.picked = '',
    List<String>? disabled,
    required this.ifChange,
    this.labelStyle = const TextStyle(),
    Color? activeColor, //defaults to toggleableActiveColor,
    this.padding = const EdgeInsets.all(3),
    this.margin = const EdgeInsets.all(3),
  });

  @override
  _RadioTileOptionsState createState() => _RadioTileOptionsState();
}

class _RadioTileOptionsState extends State<RadioTileOptions> {
  String _selected = ""; //组件所选

  @override
  void initState() {
    super.initState();
    print("进入_RadioTileOptionsState的初始化");
    //set the selected to the picked (if not null)
    // _selected = widget.picked ?? "";
    _selected = widget.picked;
  }

  @override
  Widget build(BuildContext context) {
    //set the selected to the picked (if not null)
    _selected = widget.picked; //若无此设置 则会继承上一个题的选择值

    List<Widget> content = []; //存放自定义组合的组件
    // final size = MediaQuery.of(context).size;

    for (int i = 0; i < widget.labels.length; i++) {
      //遍历几个选项
      Text t = Text(
        widget.labels.elementAt(i),
        style: TextStyle(
            color: _selected == widget.labels.elementAt(i)
                ? AppColors.pPurple
                : Colors.black,
            fontSize: 16 * MediaQSize.heightRefScale,
            fontWeight: FontWeight.w500),
      );

      RadioListTile rb = RadioListTile(
        activeColor: AppColors.pPurple, // 将圆圈颜色设为透明
        // controlAffinity: ListTileControlAffinity.trailing, // 将圆圈移动到标题后面
        secondary: _selected == widget.labels.elementAt(i)
            ? Icon(
                Icons.check,
                color: AppColors.pPurple,
                size: 22 * MediaQSize.heightRefScale,
              ) // 对勾图标
            : Icon(Icons.check_box_outline_blank,
                color: Colors.transparent,
                size: 22 * MediaQSize.heightRefScale), // 未选中图标
        contentPadding: const EdgeInsets.only(left: 0, top: 3) *
            MediaQSize.heightRefScale, //设置选项卡的格式
        groupValue: widget.labels.indexOf(_selected), //选中的
        value: i,
        title: Container(
            //文字
            padding: EdgeInsets.only(left: 30 * MediaQSize.widthRefScale),
            alignment: Alignment.centerLeft,
            height: 40 * MediaQSize.heightRefScale,
            decoration: BoxDecoration(
              color: _selected == widget.labels.elementAt(i)
                  ? AppColors.lPurple
                  : AppColors.lightblue,
              borderRadius:
                  BorderRadius.circular(12) * MediaQSize.widthRefScale,
            ),
            child: t),
        //单选
        onChanged: (widget.disabled.contains(widget.labels.elementAt(i)))
            ? null
            : (var index) => setState(() {
                  _selected = widget.labels.elementAt(i);
                  widget.ifChange(widget.labels.elementAt(i), i); //反向调用
                  //调用父组件的onchange，也是调用才传入
                  //elementAt(i)返回i-th元素的string类型
                }),
      );

      // print("启动build"); //入了

      content.add(rb);
      content.add(const Divider(
        color: Colors.white,
      ));
      // print("debug加了");
    }
    // print("debug加了");

    return Column(children: [Column(children: content)]);
  }
}
