class SubjectModel {
  final int id;
  final String subjectName;
  final int groupId;
  final int courseId;
  final int batchId;
  final int branchId;
  final int status;

  SubjectModel({
    required this.id,
    required this.subjectName,
    required this.groupId,
    required this.courseId,
    required this.batchId,
    required this.branchId,
    required this.status,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? 0,
      subjectName: json['subject'] ?? '',
      groupId: json['group_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      branchId: json['branch_id'] ?? 0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
