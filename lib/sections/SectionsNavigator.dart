//以下为文件2-SectionsNavigator.dart中的内容：
import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:tinnitus_quizs/sections/qrDisplayPage.dart';
import 'package:tinnitus_quizs/sections/quizLocalHisPage.dart';
import '../../configs/app_colors.dart';
import '../configs/media_QSize.dart';
import 'quizSelectionPage.dart';

//底部一级目录导航 sectiions 的切换（使用bottomnavigationbar）
class SectionsNavigator extends StatefulWidget {
  int bottomIdx = 0; //一级目录默认位置
  SectionsNavigator({super.key, required this.bottomIdx});
  @override
  State<SectionsNavigator> createState() => _SectionsNavigatorState();
}

class _SectionsNavigatorState extends State<SectionsNavigator> {
  final List<Widget> _sections = [
    //一级目录 section  底部3 模块
    const QuizSelectionPage(),
    const qrDisplayPage(),
    const QuizLocalHisPage()
  ];

  @override
  void initState() {
    // 在某个有状态的组件中 关闭启动屏
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      FlutterSplashScreen.hide();
    }); // Future.delayed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // centerTitle: true,
      //   backgroundColor: AppColors.bule0, //最高栏楣 较深色
      //   toolbarHeight: 50, //leading和title那行的位置高度
      //   title: const Text(
      //     '耳鸣主观量表App',
      //     style: TextStyle(fontSize: 19),
      //   ), //共有的简化
      // ),

      body: _sections[widget.bottomIdx], //默认从第三模块

      bottomNavigationBar: BottomNavigationBar(
          iconSize: 38 * MediaQSize.heightRefScale, //底部菜单大小
          unselectedLabelStyle: const TextStyle(fontSize: 18),
          selectedLabelStyle: const TextStyle(fontSize: 20),
          selectedIconTheme: IconThemeData(
              color: AppColors.blueshine,
              size: 50 * MediaQSize.heightRefScale), //选中图标配色
          currentIndex: widget.bottomIdx, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //底部同时有＞3个的sections的时候 必须配置
          elevation: 20 * MediaQSize.heightRefScale,
          onTap: (index) {
            //点击菜单触发的方法
            setState(() {
              widget.bottomIdx = index; //index为当前被点击的索引
            });
          },
          //配合的
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_outlined), //大小在上面配置了
              label: "耳鸣问诊",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "生成二维码"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_sharp), label: "本地记录"),
          ]),

      // floatingActionButton: Container(
      //   height: 70, //调整FloatingActionButton的大小
      //   width: 70,
      //   padding: const EdgeInsets.all(5),
      //   margin: const EdgeInsets.only(top: 37), //调整FloatingActionButton的位置
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      //   child: FloatingActionButton(
      //       backgroundColor: _currentIndex == 2
      //           ? AppColors.blueshine
      //           : Colors.grey, //选中就蓝色 没选中就灰色
      //       child: const Icon(
      //         // Icons.play_circle_fill_outlined,
      //         Icons.qr_code,
      //         size: 30,
      //       ), //浮动组件的图标
      //       onPressed: () {
      //         setState(() {
      //           // _currentIndex = 2;
      //           Navigator.pushNamed(context, '/qrDisplay');
      //         });
      //       }),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked, //配置浮动按钮的位置
    );
  }
}
