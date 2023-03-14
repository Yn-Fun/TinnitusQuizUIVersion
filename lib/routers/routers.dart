// import 'package:flutter/material.dart';
// import '../loginPage.dart';
// import '../pages/quizLocalHispage.dart';
// import '../pages/qrDisplay.dart';
// import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';

//原来用于专门配置routes 但后面为了方便 统一集合到了main上
//由section跳到某个page
//1、配置路由(问卷)
// 

// Map routes = {
//   // "/": (contxt) => const SectionsNavigator(), //默认界面(已修改)
//   // "/quizselection": (ctx) => const SectionsNavigator(), //暂定为默认界面
//   "/quizhistory": (contxt) => const QuizLocalHisPage(),
//   '/login': (BuildContext context) => const LoginPage(),
//   '/qrDisplay': (contxt) => qrDisplayPage(data: StoreQuizs.strdata), //写入二维码数据
// };



// 路由管理统一采用直接navigator的方法，不使用自定义onGenerate了
// //2、配置onGenerateRoute  固定写法  这个方法也相当于一个中间件，这里可以做权限判断
// var onGenerateRoute = (RouteSettings settings) {
//   final String? name = settings.name; //
//   final Function? pageContentBuilder =
//       routes[name]; //  Function = (contxt) { return const NewsPage()}

//   if (pageContentBuilder != null) {
//     //为路由传值做解析（不过目前没用）
//     if (settings.arguments != null) {
//       final Route aroute = MaterialPageRoute(
//           builder: (context) =>
//               pageContentBuilder(context, arguments: settings.arguments),
//           fullscreenDialog: true //已改 新的路由页面是否是一个全屏的模态对话框
//           );
//       return aroute;
//     }
//     //如果路由不用有参数
//     else {
//       final Route aRoute =
//           MaterialPageRoute(builder: (context) => pageContentBuilder(context));
//       return aRoute;
//     }
//   }
//   return null;
// };
