import 'assessment.dart';

class Student {
  String id;
  String name;
  List<Assessment> assessments;

  Student({
    required this.id,
    required this.name,
    required this.assessments,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assessments': assessments.map((a) => a.toJson()).toList(),
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        assessments: (json['assessments'] as List)
            .map((a) => Assessment.fromJson(Map<String, dynamic>.from(a)))
            .toList(),
      );
}