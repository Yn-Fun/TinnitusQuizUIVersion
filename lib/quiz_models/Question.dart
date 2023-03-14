import 'Answer.dart';

class Question {
  final String questiontext;
  final List<Answer> answers;

  Question({
    required this.questiontext,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questiontext: json['questiontext'],
        answers: List<Answer>.from(json['answers']
            .map((x) => Answer.fromJson(x))), //调用 Answer.fromJson
      );

  Map<String, dynamic> toJson() => {
        'questiontext': questiontext,
        'answers': List<dynamic>.from(answers.map((x) => x.toJson())),
      };

  @override
  String toString() => toJson().toString();
}
