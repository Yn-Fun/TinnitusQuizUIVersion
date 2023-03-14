class ResultRankRef {
  final int rankpoints;
  final String rankdescriptions;

  ResultRankRef({
    required this.rankpoints,
    required this.rankdescriptions,
  });

  factory ResultRankRef.fromJson(Map<String, dynamic> json) => ResultRankRef(
        rankpoints: json['rankpoints'],
        rankdescriptions: json['rankdescriptions'],
      );

  Map<String, dynamic> toJson() => {
        'rankpoints': rankpoints,
        'rankdescriptions': rankdescriptions,
      };

  @override
  String toString() => toJson().toString();
}
