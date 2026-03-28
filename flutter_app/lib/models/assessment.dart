class Assessment {
  String name;
  double score;
  double weight;

  Assessment({
    required this.name,
    required this.score,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'weight': weight,
      };

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        name: json['name'],
        score: (json['score'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
      );
}