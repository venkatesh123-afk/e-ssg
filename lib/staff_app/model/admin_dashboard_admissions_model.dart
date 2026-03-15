class AdminDashboardAdmissionsModel {
  String? success;
  Infodata? infodata;

  AdminDashboardAdmissionsModel({this.success, this.infodata});

  AdminDashboardAdmissionsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    infodata = json['infodata'] != null ? Infodata.fromJson(json['infodata']) : null;
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

class Infodata {
  int? totalStudentsCount;
  int? boysStudentsCount;
  int? girlsStudentsCount;
  int? dayStudentsCount;
  int? hostelStudentsCount;
  List<TotalBranchInfo>? totalBranchInfo;

  Infodata({
    this.totalStudentsCount,
    this.boysStudentsCount,
    this.girlsStudentsCount,
    this.dayStudentsCount,
    this.hostelStudentsCount,
    this.totalBranchInfo,
  });

  Infodata.fromJson(Map<String, dynamic> json) {
    totalStudentsCount = json['total_students_count'];
    boysStudentsCount = json['boys_students_count'];
    girlsStudentsCount = json['girls_students_count'];
    dayStudentsCount = json['day_students_count'];
    hostelStudentsCount = json['hostel_students_count'];
    if (json['total_branch_info'] != null) {
      totalBranchInfo = <TotalBranchInfo>[];
      json['total_branch_info'].forEach((v) {
        totalBranchInfo!.add(TotalBranchInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_students_count'] = totalStudentsCount;
    data['boys_students_count'] = boysStudentsCount;
    data['girls_students_count'] = girlsStudentsCount;
    data['day_students_count'] = dayStudentsCount;
    data['hostel_students_count'] = hostelStudentsCount;
    if (totalBranchInfo != null) {
      data['total_branch_info'] = totalBranchInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalBranchInfo {
  String? branchName;
  int? total;
  int? male;
  int? female;
  int? converted;

  TotalBranchInfo({
    this.branchName,
    this.total,
    this.male,
    this.female,
    this.converted,
  });

  TotalBranchInfo.fromJson(Map<String, dynamic> json) {
    branchName = json['branch_name'];
    total = json['Total'];
    male = json['MALE'];
    female = json['FEMALE'];
    converted = json['CONVERTED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_name'] = branchName;
    data['Total'] = total;
    data['MALE'] = male;
    data['FEMALE'] = female;
    data['CONVERTED'] = converted;
    return data;
  }
}
