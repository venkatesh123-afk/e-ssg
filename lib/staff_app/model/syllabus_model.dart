class SyllabusModel {
  final int id;
  final int branchId;
  final int groupId;
  final int courseId;
  final int batchId;
  final int subjectId;
  final String chapterName;
  final String expectedStartDate;
  final String expectedAccomplishedDate;
  final String? actualStartDate;
  final String? actualCompletedDate;
  final int progressPercent;

  final String? subjectName;
  final String? batchName;
  final String? branchName;
  final String? courseName;
  final String? groupName;

  // New fields from API response (Postman)
  final int? trackingStatus;
  final String? trackingRemarks;
  final int? sessionId;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  SyllabusModel({
    required this.id,
    required this.branchId,
    required this.groupId,
    required this.courseId,
    required this.batchId,
    required this.subjectId,
    required this.chapterName,
    required this.expectedStartDate,
    required this.expectedAccomplishedDate,
    this.actualStartDate,
    this.actualCompletedDate,
    required this.progressPercent,
    this.subjectName,
    this.batchName,
    this.branchName,
    this.courseName,
    this.groupName,
    this.trackingStatus,
    this.trackingRemarks,
    this.sessionId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SyllabusModel.fromMap(Map<String, dynamic> map) {
    return SyllabusModel(
      id: map['id'] ?? 0,
      branchId: map['branch_id'] is int ? map['branch_id'] : int.tryParse(map['branch_id'].toString()) ?? 0,
      groupId: map['group_id'] is int ? map['group_id'] : int.tryParse(map['group_id'].toString()) ?? 0,
      courseId: map['course_id'] is int ? map['course_id'] : int.tryParse(map['course_id'].toString()) ?? 0,
      batchId: map['batch_id'] is int ? map['batch_id'] : int.tryParse(map['batch_id'].toString()) ?? 0,
      subjectId: map['subject_id'] is int ? map['subject_id'] : int.tryParse(map['subject_id'].toString()) ?? 0,
      chapterName: map['chapter_name'] ?? map['tracking_remarks'] ?? '', // Fallback to remarks if name empty
      expectedStartDate: map['expected_start_date'] ?? map['start_date'] ?? (map['created_at'] != null ? map['created_at'].toString().split(' ')[0] : ''),
      expectedAccomplishedDate: map['expected_accomplished_date'] ?? map['accomplished_date'] ?? (map['updated_at'] != null ? map['updated_at'].toString().split(' ')[0] : ''),
      actualStartDate: map['actual_start_date'],
      actualCompletedDate: map['actual_completed_date'],
      progressPercent: map['progress_percent'] is int ? map['progress_percent'] : int.tryParse(map['progress_percent'].toString()) ?? 0,
      subjectName: map['subject_name'],
      batchName: map['batch_name'],
      branchName: map['branch_name'],
      courseName: map['coursename'],
      groupName: map['groupname'],
      trackingStatus: map['tracking_status'] is int ? map['tracking_status'] : int.tryParse(map['tracking_status'].toString()),
      trackingRemarks: map['tracking_remarks'],
      sessionId: map['session_id'] is int ? map['session_id'] : int.tryParse(map['session_id'].toString()),
      status: map['status'] is int ? map['status'] : int.tryParse(map['status'].toString()),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      deletedAt: map['deleted_at'],
    );
  }
}
