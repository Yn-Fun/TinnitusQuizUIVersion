import 'package:flutter/widgets.dart';

class MediaQSize {
  static Size thisDsize = const Size(600.0,
      912.0); //当前设备的显示尺寸。提前赋一个预设值，app中有“ WidgetsApp or MaterialApp“组件，是逻辑尺寸 用于显示的 不是真实的

  static Size refDsize =
      const Size(600.0, 912.0); //参考7寸的，用来做对照，Size(600.0, 912.0)是7寸的平板的逻辑尺寸dp
  static double widthRefScale = 1; //缩放比例 =当前/之前（对照的）  用来调整
  static double heightRefScale = 1; //缩放比例 =当前/之前（对照的）  用来调整

  void initMQ(BuildContext context) {
    MediaQSize.thisDsize = MediaQuery.of(context).size; //获取当前设备的值
    print("当前设备的页面逻辑尺寸:${MediaQSize.thisDsize}"); // Size(600.0, 912.0)
    MediaQSize.widthRefScale =
        MediaQSize.thisDsize.width / MediaQSize.refDsize.width; //计算水平缩放比
    MediaQSize.heightRefScale =
        MediaQSize.thisDsize.height / MediaQSize.refDsize.height;
    print(
        "缩放比分别为: 水平：${MediaQSize.widthRefScale}；竖直：${MediaQSize.heightRefScale}"); // Size(600.0, 912.0)
    // 参考7寸Size(600.0, 912.0)，
    // 当前10寸:Size(800.0, 1232.0)
  }
}
