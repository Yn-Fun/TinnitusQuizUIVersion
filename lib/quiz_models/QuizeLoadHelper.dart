import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'Quiz_types.dart';
import 'QuizInfo.dart';

//返回的是json文件路径

class QuizLoadHelper {
  String _getQuizAssetPath(QuizTypes quizType) {
    switch (quizType) {
      case QuizTypes.THI:
        print('THI');
        return 'assets/questionnaires/THI_1.json';
      case QuizTypes.VAS:
        print('VAS');
        return 'assets/questionnaires/VAS_2.json';
      case QuizTypes.TFI:
        {
          print('TFI');
          return 'assets/questionnaires/TFI_3.json';
        }
      case QuizTypes.TEQ:
        print('SAS');
        return 'assets/questionnaires/TEQ_4.json';

      case QuizTypes.PSQI: //未
        print('PSQI');
        return 'assets/questionnaires/PSQI_5.json';
      default:
        return '';
    }
  }

//返回:json路径 读取从json转化后的 QuizInfo类的量表
  Future<QuizInfo> getQuiz(QuizTypes quizType) async {
    //一串联 assetPath[string路径] --> jsondata[string资源] --> jsonDataDecoded[dynamic对应的数据类型 可能是map]
    final assetPath = _getQuizAssetPath(quizType); //路径
    final jsonData =
        await rootBundle.loadString(assetPath); //加载json中的数据，存储的字符串采用 UTF-8 编码
    final jsonDataDecoded = jsonDecode(jsonData);
    return QuizInfo.fromJson(
        jsonDataDecoded); //调用Quizinfo中的QuizInfo.fromJson(Map<String, dynamic> json)
  }
}
