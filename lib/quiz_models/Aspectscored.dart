class Aspectscorerd {
  double aspectScore;
  String aspectName;
  String? aspectRank_VAS = '';

  Aspectscorerd({
    required this.aspectScore,
    required this.aspectName,
    this.aspectRank_VAS, //为VAS细分后加的
  });

  factory Aspectscorerd.fromJson(Map<String, dynamic> json) => Aspectscorerd(
        aspectScore: json['aspectScore'],
        aspectName: json['aspectName'],
      );

  Map<String, dynamic> toJson() => {
        'aspectScore': aspectScore,
        'aspectName': aspectName,
      };

  @override
  String toString() => toJson().toString();
}
