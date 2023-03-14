import 'ResultRankRef.dart';
import 'Question.dart';
import 'UserResultRecord.dart';

//定义一个总类，用来统领 描述和解释问卷
class QuizInfo {
  final String quizName;
  final String quizInstructions;
  final List<Question> quizTextandValues;
  final List<ResultRankRef> quizResultRankRef;
  UsersResultRecords quizusersResult;
  // = UsersResultRecords(
  //     //自定义 注意区别 不是list
  //     userrankrd: '',
  //     userrawscorerd: 0,
  //     userAspectScores: List<Aspectscorerd>[]); //为满足null safety
  // static const String defuserrank = 'normal'; //用于
  // static const double defuserscore = 0;
  // var usersResultRecords;

  QuizInfo({
    required this.quizName,
    required this.quizInstructions,
    required this.quizTextandValues, //问题+答案文本+对应分数
    required this.quizResultRankRef, //结果
    required this.quizusersResult, //自己加的
  });

//输入: 从jsonmodel中转化得到的Map：jsondatadecode；
//输出：Quizinfo类的问卷类[一个一个key匹配]
  factory QuizInfo.fromJson(Map<String, dynamic> jsonDataDecoded) => QuizInfo(
      //设定json的类别是：Map<String, dynamic>
      quizName: jsonDataDecoded['Name'],
      quizInstructions: jsonDataDecoded['Instructions'],
      quizTextandValues: List<Question>.from(
          jsonDataDecoded['TextandValues'].map((x) => Question.fromJson(x))),
      quizResultRankRef: List<ResultRankRef>.from(
          jsonDataDecoded['ResultRankRef']
              .map((x) => ResultRankRef.fromJson(x))),
      // 初始化一个
      // quizusersResult: UsersResultRecords(
      //     userrankrd: '', userrawscorerd: 0, userAspectScores: [])

      // quizusersResult: UsersResultRecords(userrankrd:jsonDataDecoded['UserResult'](userrankrd:jsonDataDecoded['userrankrd'],), userAspectScores: [], userrawscorerd: null,)
      quizusersResult:
          UsersResultRecords.fromJson(jsonDataDecoded['UserResult'][0]));

//JSON转Dart类 的model类函数
  Map<String, dynamic> toJson() => {
        'Name': quizName,
        'Instructions': quizInstructions,
        'TextandValues':
            List<dynamic>.from(quizTextandValues.map((x) => x.toJson())),
        'ResultRankRef':
            List<dynamic>.from(quizResultRankRef.map((x) => x.toJson())),
//TODO:检测写入
        'UserResult': quizusersResult.toJson(),
      };

  @override
  String toString() => toJson().toString();
}
