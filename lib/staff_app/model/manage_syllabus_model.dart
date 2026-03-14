class ManageSyllabusModel {
  final int id;
  final String subjectName;
  final String syllabus;
  final bool hasSyllabus;

  ManageSyllabusModel({
    required this.id,
    required this.subjectName,
    required this.syllabus,
    required this.hasSyllabus,
  });

  factory ManageSyllabusModel.fromMap(Map<String, dynamic> map) {
    return ManageSyllabusModel(
      id: map['id'] ?? 0,
      subjectName: map['subject_name'] ?? '',
      syllabus: map['syllabus'] ?? '',
      hasSyllabus: map['has_syllabus'] == true || map['has_syllabus'] == "true",
    );
  }
}
