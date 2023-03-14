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
  WidgetsFlutterBinding.ensureInitialized();
  await requestExternalStoragePermission();
  deletePrivateDownloadApk();
  deletePrivateFileApk();
  deletePrivateRootApk();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '耳鸣主观量表App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: AppColors.blue1,
        ),
        scaffoldBackgroundColor: AppColors.blue2,
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        primaryTextTheme: const TextTheme(
          headline5: TextStyle(
              color: AppColors.blueshine, fontWeight: FontWeight.w900),
          bodyText1:
              TextStyle(color: AppColors.darkgray, fontWeight: FontWeight.w500),
        ),
        disabledColor: AppColors.lightgray,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      routes: {
        "/": (contxt) => SectionsNavigator(bottomIdx: 0),
        "/SectionsMain": (contxt) => SectionsNavigator(bottomIdx: 0),
        "/quizSelction": (ctx) => const QuizSelectionPage(),
        "/quizhistory": (contxt) => const QuizLocalHisPage(),
        '/qrDisplay': (contxt) => const qrDisplayPage(),
      },
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
    log('私有目录/files：此路径当前无文件删除', name: '私有目录-files');
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
    log('私有目录/Download：此路径当前无文件删除', name: '私有目录-Download');
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
    log('私有目录-根：此路径当前无文件删除', name: '私有目录-根');
  }
}

Future<void> requestExternalStoragePermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      var result = await Permission.manageExternalStorage.request();
      if (result != PermissionStatus.granted) {
        return;
      }
    }
  }
}
