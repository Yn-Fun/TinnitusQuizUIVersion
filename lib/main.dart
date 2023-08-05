//以下为文件1-main.dart中的内容：
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinnitus_quizs/quiz_intros/vas_intro.dart';
import 'dart:io';
import 'package:tinnitus_quizs/bottom_sections/qrDisplayPage.dart';
import 'package:tinnitus_quizs/bottom_sections/quizLocalHisPage.dart';
import 'package:tinnitus_quizs/bottom_sections/quizSelectionPage.dart';
import '../configs/app_colors.dart';
import 'quiz_intros/psqi_intro.dart';
import 'quiz_intros/teq_intro.dart';
import 'quiz_intros/tfi_intro.dart';
import 'quiz_intros/thi_intro.dart';
import 'bottom_sections/SectionsNavigator.dart';

void main() async {
  // 初始化绑定，导入这些库
  WidgetsFlutterBinding.ensureInitialized();

  // testPathProviderFuns();
  // 请求外部存储器访问权限
  // requestManageExternalStoragePermission(); //会弹窗

  await requestStoragePermission(); //请求权限

  //删除外部存储的私有目录的3个常见文件夹下面的apk：
  //目录1：Android/data/com.example.QEHS/files
  //目录2：Android/data/com.example.QEHS/files/Download
  //目录3：Android/data/com.example.QEHS
  deletePrivateApks();

  //删除外部存储的公共目录下的文件都不行(2023-3-18可行了)
  deletePublicApks();
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
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: AppColors.pPurple, //楣
        ),
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        primaryTextTheme: const TextTheme(
          // headline1: TextStyle(color: Colors.white),
          headline5:
              TextStyle(color: AppColors.pPurple, fontWeight: FontWeight.w900),
          bodyText1:
              TextStyle(color: AppColors.darkgrey, fontWeight: FontWeight.w500),
        ),
        disabledColor: AppColors.lightblue,
      ),

      // initialRoute: "/",
      // onGenerateRoute: onGenerateRoute, //统一由routers管理
      //home 和 ‘/’只能有一个
      routes: {
        "/": (contxt) => SectionsNavigator(bottomIdx: 0), //默认
        "/quizSelction": (ctx) => const QuizSelectionPage(), //暂定为默认界面
        "/quizhistory": (contxt) => const QuizLocalHisPage(),
        '/qrDisplay': (contxt) => const QrDisplayPage(), //写入二维码数据
        '/thiIntro': (contxt) => const thiIntroPage(),
        '/vasIntro': (contxt) => const vasIntroPage(),
        '/tfiIntro': (contxt) => const tfiIntroPage(),
        '/teqIntro': (contxt) => const teqIntroPage(),
        '/psqiIntro': (contxt) => const PSQIIntroPage(),
      },
    );
  }
}

Future<void> deletePrivateApks() async {
  final externalStorageDir = await getExternalStorageDirectory();
  //目录1：Android/data/com.example.TinnQuizQEHS/files
  final fileDir = Directory('${externalStorageDir?.path}');
  log('私有目录/files：${externalStorageDir?.path}', name: '私有目录-files');
  //目录2：Android/data/com.example.QEHS/files/Download
  final dldDir = Directory('${externalStorageDir?.path}');
  log('私有目录/Download：${externalStorageDir?.path}/Download',
      name: '私有目录/Download');
  //目录3：Android/data/com.example.QEHS
  final rootDir = Directory((externalStorageDir?.path)!
      .substring(0, (externalStorageDir?.path)?.indexOf("/files")));
  log('私有目录-根：${dldDir.path}', name: '私有目录-根');

  var apkFilesList =
      fileDir.listSync().where((file) => file.path.endsWith('.apk')).toList();
  apkFilesList.addAll(dldDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList()); //合并1
  apkFilesList.addAll(rootDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList()); //合并2

  if (apkFilesList.isNotEmpty) {
    for (final apkFile in apkFilesList) {
      await apkFile.delete();
    }
  } else {
    log('私有目录的各路径 下面当前都无文件删除', name: '私有目录');
  }
}

//本来 会报错为：
// FileSystemException (FileSystemException: Directory listing failed, path = '/storage/emulated/0/' (OS Error: Permission denied, errno = 13))
// 因为AS10及以上，无法删除外部存储器目录下的公共目录 ："/storage/emulated/0/ 里面的apk文件
// 但是额外添加了配置：android:requestLegacyExternalStorage="true" ！必要的！
// 但目前还是无法删除SD卡里面的
Future<void> deletePublicApks() async {
  final publicDownloadDir =
      Directory('/storage/emulated/0/Download'); //公共目录的download
  log('公共目录：自带外部存储的公共目录$publicDownloadDir');
  var publicRootDir = Directory('/storage/emulated/0/');

  var apkFilesList = publicDownloadDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList();

  apkFilesList.addAll(publicRootDir
      .listSync()
      .where((file) => file.path.endsWith('.apk'))
      .toList()); //统一合并到1

  if (apkFilesList.isNotEmpty) {
    for (final apkFile in apkFilesList) {
      await apkFile.delete();
      print('删除中');
    }
  } else {
    print('公共目录没有要删除的APK files');
  }
}

//请求外部存储器访问权限 会弹窗 但好像也没有什么用
Future<void> requestManageExternalStoragePermission() async {
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

//请求访问外部存储器
Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isDenied) {
    print("请求失败");
    // 提醒用户手动授权
  }
}

void testPathProviderFuns() async {
  //测试path_privider的几个方法
//目录："/data/user/0/com.example.QEHS/cache"
  final testTemp = await getTemporaryDirectory();

  //目录："/data/user/0/com.example.QEHS/files"
  final testAppSupportD = await getApplicationSupportDirectory();

  /// 目录"/data/user/0/com.example.QEHS/app_flutter"
  final testAppDocumcum = await getApplicationDocumentsDirectory();

  //类似getExternalStorageDirectories
  final testExtcache = await getExternalCacheDirectories();

  final testExtdir = await getExternalStorageDirectories();

  // final testDownld = await getDownloadsDirectory();//不是安卓的
  // final testLibraryD = await getLibraryDirectory();//不是安卓用的
}
