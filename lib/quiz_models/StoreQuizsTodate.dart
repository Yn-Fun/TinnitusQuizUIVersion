import 'package:tinnitus_quizs/quiz_models/QuizInfo.dart';

// 用来共享的全局变量
class StoreQuizs {

  //加载显示的QuizInfo类的List
  static List<QuizInfo> quizsList = []; //按顺序存放加载后的5个问卷

  static List<QuizInfo>? quizInfoTotalRcnList; //类似堆栈,多次结果可以叠加[历史全记录]

  //最近一套（5类各一）的5份结果
  static List<num>? THIqrNumData;
  static List<num>? VASqrNumData;
  static List<num>? TFIqrNumData;
  static List<num>? TEQqrNumData;
  static List<num>? PSQIqrNumData;

  // 给QR做铺垫
  static String strdata = 'THI,NA;VAS,NA;TFI,NA;TEQ,NA;PSQI,NA;';

  static clearAllQuizs() {
    StoreQuizs.quizInfoTotalRcnList = null;
    StoreQuizs.strdata = 'THI,NA;VAS,NA;TFI,NA;TEQ,NA;PSQI,NA;';
    QuizsJust5.VASLists = null;
    QuizsJust5.THILists = null;
    QuizsJust5.TFILists = null;
    QuizsJust5.TEQLists = null;
    QuizsJust5.PSQILists = null;
  }
}

//将QuizRcnHisInfo;按照类别分
class QuizsJust5 {
  static List<QuizInfo>? THILists;
  static List<QuizInfo>? VASLists;
  static List<QuizInfo>? TFILists;
  static List<QuizInfo>? TEQLists;
  static List<QuizInfo>? PSQILists;
}
