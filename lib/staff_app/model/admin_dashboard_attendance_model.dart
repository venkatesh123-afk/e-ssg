class AdminDashboardAttendanceModel {
  String? success;
  AttendanceInfodata? infodata;

  AdminDashboardAttendanceModel({this.success, this.infodata});

  AdminDashboardAttendanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    infodata = json['infodata'] != null
        ? AttendanceInfodata.fromJson(json['infodata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (infodata != null) {
      data['infodata'] = infodata!.toJson();
    }
    return data;
  }
}

class AttendanceInfodata {
  int? staffCount;
  int? studentAttendanceCount;
  int? totalTodaysOutingCount;
  int? totalTodaysHomepassOutingCount;
  int? totalTodaysOutpassOutingCount;
  int? totalTodaysSelfpassOutingCount;
  int? staffAttendanceCount;
  List<dynamic>? batchwiseattendance;
  List<AttendanceClassSummary>? classAttendanceSummary;

  AttendanceInfodata(
      {this.staffCount,
      this.studentAttendanceCount,
      this.totalTodaysOutingCount,
      this.totalTodaysHomepassOutingCount,
      this.totalTodaysOutpassOutingCount,
      this.totalTodaysSelfpassOutingCount,
      this.staffAttendanceCount,
      this.batchwiseattendance,
      this.classAttendanceSummary});

  AttendanceInfodata.fromJson(Map<String, dynamic> json) {
    staffCount = json['staff_count'];
    studentAttendanceCount = json['student_attendance_count'];
    totalTodaysOutingCount = json['total_todays_outing_count'];
    totalTodaysHomepassOutingCount = json['total_todays_homepass_outing_count'];
    totalTodaysOutpassOutingCount = json['total_todays_outpass_outing_count'];
    totalTodaysSelfpassOutingCount = json['total_todays_selfpass_outing_count'];
    staffAttendanceCount = json['staff_attendance_count'];
    if (json['batchwiseattendance'] != null) {
      batchwiseattendance = <dynamic>[];
      json['batchwiseattendance'].forEach((v) {
        batchwiseattendance!.add(v);
      });
    }
    if (json['class_attendance_summary'] != null) {
      classAttendanceSummary = <AttendanceClassSummary>[];
      json['class_attendance_summary'].forEach((v) {
        classAttendanceSummary!.add(AttendanceClassSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staff_count'] = staffCount;
    data['student_attendance_count'] = studentAttendanceCount;
    data['total_todays_outing_count'] = totalTodaysOutingCount;
    data['total_todays_homepass_outing_count'] = totalTodaysHomepassOutingCount;
    data['total_todays_outpass_outing_count'] = totalTodaysOutpassOutingCount;
    data['total_todays_selfpass_outing_count'] = totalTodaysSelfpassOutingCount;
    data['staff_attendance_count'] = staffAttendanceCount;
    if (batchwiseattendance != null) {
      data['batchwiseattendance'] = batchwiseattendance;
    }
    if (classAttendanceSummary != null) {
      data['class_attendance_summary'] =
          classAttendanceSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceClassSummary {
  String? branchName;
  Map<String, AttendanceShift>? shifts;

  AttendanceClassSummary({this.branchName, this.shifts});

  AttendanceClassSummary.fromJson(Map<String, dynamic> json) {
    branchName = json['branch_name'];
    if (json['shifts'] != null) {
      shifts = {};
      json['shifts'].forEach((key, value) {
        shifts![key] = AttendanceShift.fromJson(value);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_name'] = branchName;
    if (shifts != null) {
      data['shifts'] = shifts!.map((key, value) => MapEntry(key, value.toJson()));
    }
    return data;
  }
}

class AttendanceShift {
  String? shiftName;
  AttendanceData? day;
  AttendanceData? hostel;

  AttendanceShift({this.shiftName, this.day, this.hostel});

  AttendanceShift.fromJson(Map<String, dynamic> json) {
    shiftName = json['shift_name'];
    day = json['Day'] != null ? AttendanceData.fromJson(json['Day']) : null;
    hostel =
        json['Hostel'] != null ? AttendanceData.fromJson(json['Hostel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shift_name'] = shiftName;
    if (day != null) {
      data['Day'] = day!.toJson();
    }
    if (hostel != null) {
      data['Hostel'] = hostel!.toJson();
    }
    return data;
  }
}

class AttendanceData {
  int? total;
  int? present;
  int? absent;

  AttendanceData({this.total, this.present, this.absent});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    present = json['Present'];
    absent = json['Absent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Total'] = total;
    data['Present'] = present;
    data['Absent'] = absent;
    return data;
  }
}
