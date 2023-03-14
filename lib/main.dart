//以下为文件1-main.dart中的内容：
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:tinnitus_quizs/sections/qrDisplayPage.dart';
import 'package:tinnitus_quizs/sections/quizLocalHisPage.dart';
import 'package:tinnitus_quizs/sections/quizSelectionPage.dart';
import '../configs/app_colors.dart';
import 'sections/SectionsNavigator.dart';

void main() async {
  // 初始化绑定，导入这些库
  WidgetsFlutterBinding.ensureInitialized();
  // 请求外部存储器访问权限
  await requestExternalStoragePermission();
//删除外部存储的私有目录的文件
  deletePrivateDownloadApk(); //删除目录：Android/data/com.example.QEHS/files/Download
  deletePrivateFileApk(); //删除目录：Android/data/com.example.QEHS/files
  deletePrivateRootApk(); //删除私有目录根目录：Android/data/com.example.QEHS
  // deletePublicApk();//除了私有目录 其他文件都不行
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '耳鸣主观量表App',
      debugShowCheckedModeBanner: false, //去掉debug图标
      theme: ThemeData(
        // primarySwatch: Colors.blue
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: AppColors.blue1, //楣
        ),

        scaffoldBackgroundColor: AppColors.blue2, //背景色
        // cardColor: Colors.white,
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),

        primaryTextTheme: const TextTheme(
          // headline1: TextStyle(color: Colors.white),
          headline5: TextStyle(
              color: AppColors.blueshine, fontWeight: FontWeight.w900),
          bodyText1:
              TextStyle(color: AppColors.darkgray, fontWeight: FontWeight.w500),
        ),
        disabledColor: AppColors.lightgray,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),

      // initialRoute: "/",
      // onGenerateRoute: onGenerateRoute, //统一由routers管理
      //home 和 ‘/’只能有一个
      routes: {
        "/": (contxt) => SectionsNavigator(bottomIdx: 0), //默认
        "/SectionsMain": (contxt) => SectionsNavigator(
            bottomIdx: 0), //默认一级界面，则只会返回到一级，不一定哪一页//bottomIdx: 0
        "/quizSelction": (ctx) => const QuizSelectionPage(), //暂定为默认界面
        "/quizhistory": (contxt) => const QuizLocalHisPage(),
        '/qrDisplay': (contxt) => const qrDisplayPage(), //写入二维码数据
      },

// ════════════════════════════════════════════════════════════════════════════════
    );
  }
}

Future<void> deletePrivateFileApk() async {
  final externalStorageDir = await getExternalStorageDirectory();

  final downloadDir = Directory('${externalStorageDir?.path}');
  log('私有目录/files：${externalStorageDir?.path}', name: '私有目录-files');
  final apkFiles = downloadDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList();

  if (apkFiles.isNotEmpty) {
    for (final apkFile in apkFiles) {
      await apkFile.delete();
    }
  } else {
    log('私有目录/files：此路径当前无文件删除',
        name:
            '私有目录-files'); //目前只能删除外部存储的私有目录的文件 目录：Android/data/com.example.QEHS/files
  }
}

Future<void> deletePrivateDownloadApk() async {
  final externalStorageDir = await getExternalStorageDirectory();

  final downloadDir = Directory('${externalStorageDir?.path}');
  log('私有目录/Download：${externalStorageDir?.path}/Download',
      name: '私有目录/Download');
  final apkFiles = downloadDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList();

  if (apkFiles.isNotEmpty) {
    for (final apkFile in apkFiles) {
      await apkFile.delete();
    }
  } else {
    log('私有目录/Download：此路径当前无文件删除',
        name:
            '私有目录-Download'); //目录：Android/data/com.example.QEHS/files/Download
  }
}

Future<void> deletePrivateRootApk() async {
  final externalStorageDir = await getExternalStorageDirectory();

  final downloadDir = Directory((externalStorageDir?.path)!
      .substring(0, (externalStorageDir?.path)?.indexOf("/files")));
  log('私有目录-根：${externalStorageDir?.path}', name: '私有目录-根');
  final apkFiles = downloadDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList();

  if (apkFiles.isNotEmpty) {
    for (final apkFile in apkFiles) {
      await apkFile.delete();
    }
  } else {
    log('私有目录-根：此路径当前无文件删除', name: '私有目录-根'); //目录：Android/data/com.example.QEHS
  }
}

// //暂未使用，会报错为：
// // FileSystemException (FileSystemException: Directory listing failed, path = '/storage/emulated/0/' (OS Error: Permission denied, errno = 13))
// // 因为AS10及以上，无法删除外部存储器目录下的公共目录 ："/storage/emulated/0/ 里面的apk文件
// Future<void> deletePublicApk() async {
//   final downloadDir2 = Directory('/storage/emulated/0/Download'); //download也不行
//   print('公共目录$downloadDir2');

//   final apkFiles2 = downloadDir2
//       .listSync()
//       .where((file) => file.path.endsWith('.apk'))
//       .toList();

//   if (apkFiles2.isNotEmpty) {
//     for (final apkFile in apkFiles2) {
//       await apkFile.delete();
//     }
//   } else {
//     print('公共目录没有要删除的APK files');
//   }
// }

//请求外部存储器访问权限
Future<void> requestExternalStoragePermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      var result = await Permission.manageExternalStorage.request();

      if (result != PermissionStatus.granted) {
        // 用户拒绝了权限请求
        return;
      }
    }
  }
}
