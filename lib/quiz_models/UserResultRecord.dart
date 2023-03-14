import 'Aspectscored.dart'; //分方面的细节分数

class UsersResultRecords {
  double userrawscorerd = 0; //本问卷的得分
  String userrankrd; //本问卷最后的程度
  List<Aspectscorerd> userAspectScores; //用于计算各部分分数
  List<num>? userrawchoiceIdx; //是否存放本问卷作答序号

  UsersResultRecords(
      {required this.userrankrd,
      required this.userrawscorerd,
      required this.userAspectScores,
      this.userrawchoiceIdx});

  factory UsersResultRecords.fromJson(Map<String, dynamic> json) =>
      UsersResultRecords(
        userrankrd: json['userrankrd'],
        userrawscorerd: json['userrawscorerd'],
        userAspectScores: List<Aspectscorerd>.from(json['userAspectScores']
            .map((x) => Aspectscorerd.fromJson(x))), //调用 Aspectscorerd.fromJson
      );

  Map<String, dynamic> toJson() => {
        'userrankrd': userrankrd,
        'userrawscorerd': userrawscorerd,
        'userAspectScores':
            List<Aspectscorerd>.from(userAspectScores.map((x) => x.toJson())),
      };

  @override
  String toString() => toJson().toString();
}
