class SyllabusBatchModel {
  final int batchId;
  final int examId;
  final String branchName;
  final String courseName;
  final String groupName;
  final String batchName;

  SyllabusBatchModel({
    required this.batchId,
    required this.examId,
    required this.branchName,
    required this.courseName,
    required this.groupName,
    required this.batchName,
  });

  factory SyllabusBatchModel.fromMap(Map<String, dynamic> map) {
    return SyllabusBatchModel(
      batchId: map['batch_id'] ?? 0,
      examId: map['examid'] ?? 0,
      branchName: map['branch_name'] ?? '',
      courseName: map['course_name'] ?? '',
      groupName: map['group_name'] ?? '',
      batchName: map['batch_name'] ?? '',
    );
  }
}
