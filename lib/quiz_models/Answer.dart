class Answer {
  final int optionvalue;
  final String optiontext;

  Answer({
    required this.optionvalue,
    required this.optiontext,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        optionvalue: json['optionvalue'],
        optiontext: json['optiontext'],
      );

  Map<String, dynamic> toJson() => {
        'optionvalue': optionvalue,
        'optiontext': optiontext,
      };

  @override
  String toString() => toJson().toString();
}
