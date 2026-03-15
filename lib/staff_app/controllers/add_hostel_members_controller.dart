import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/hostel_student_model.dart';
import '../model/hostel_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';
import 'branch_controller.dart';
import 'group_controller.dart';
import 'course_controller.dart';
import 'batch_controller.dart';
import 'hostel_controller.dart';

class StudentSelection {
  final Rxn<HostelModel> selectedHostel = Rxn<HostelModel>();
  final Rxn<FloorModel> selectedFloor = Rxn<FloorModel>();
  final Rxn<RoomModel> selectedRoom = Rxn<RoomModel>();
  final RxList<FloorModel> floors = <FloorModel>[].obs;
  final RxList<RoomModel> rooms = <RoomModel>[].obs;
}

class AddHostelMembersController extends GetxController {
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());
  final HostelController hostelCtrl = Get.put(HostelController());

  // Global selections for all students
  final Rxn<HostelModel> globalHostel = Rxn<HostelModel>();
  final Rxn<FloorModel> globalFloor = Rxn<FloorModel>();
  final Rxn<RoomModel> globalRoom = Rxn<RoomModel>();
  final RxList<FloorModel> globalFloors = <FloorModel>[].obs;
  final RxList<RoomModel> globalRooms = <RoomModel>[].obs;

  final RxList<HostelStudentModel> students = <HostelStudentModel>[].obs;
  final RxMap<int, StudentSelection> selections = <int, StudentSelection>{}.obs;
  final RxBool isLoadingStudents = false.obs;
  final RxBool showData = false.obs;

  @override
  void onInit() {
    super.onInit();
    branchCtrl.loadBranches();
    
    // Setup listeners for cascading effect
    ever(branchCtrl.selectedBranch, (_) => _handleBranchChange());
    ever(groupCtrl.selectedGroup, (_) => _handleGroupChange());
    ever(courseCtrl.selectedCourse, (_) => _handleCourseChange());
  }

  void _handleBranchChange() {
    final branch = branchCtrl.selectedBranch.value;
    if (branch != null) {
      groupCtrl.loadGroups(branch.id);
      hostelCtrl.loadHostelsByBranch(branch.id);
    } else {
      groupCtrl.clear();
      hostelCtrl.hostels.clear();
    }
  }

  void _handleGroupChange() {
    final group = groupCtrl.selectedGroup.value;
    if (group != null) {
      courseCtrl.loadCourses(group.id);
    } else {
      courseCtrl.clear();
    }
  }

  void _handleCourseChange() {
    final course = courseCtrl.selectedCourse.value;
    if (course != null) {
      batchCtrl.loadBatches(course.id);
    } else {
      batchCtrl.clear();
    }
  }

  Future<void> fetchStudents() async {
    final batch = batchCtrl.selectedBatch.value;
    if (batch == null) {
      Get.snackbar("Warning", "Please select a batch first");
      return;
    }

    try {
      isLoadingStudents.value = true;
      students.clear();
      
      final data = await ApiService.getHostelMembers(
        type: "batch",
        param: batch.id.toString(),
      );
      
      students.assignAll(data.map((e) => HostelStudentModel.fromJson(e)).toList());
      
      // Initialize selections for each student
      selections.clear();
      for (var student in students) {
        selections[student.sid] = StudentSelection();
      }
      
      showData.value = true;
    } catch (e) {
      debugPrint("FETCH STUDENTS ERROR: $e");
      Get.snackbar("Error", "Failed to fetch students");
    } finally {
      isLoadingStudents.value = false;
    }
  }

  void reset() {
    showData.value = false;
    students.clear();
    selections.clear();
  }

  Future<void> saveHostelMember({
    required HostelStudentModel student,
    required String? hostelId,
    required String? floorId,
    required String room,
    required String month,
    bool showSnackbar = true,
  }) async {
    if (hostelId == null || floorId == null) {
      if (showSnackbar) {
        Get.snackbar("Warning", "Please select hostel and floor for ${student.studentName}");
      }
      return;
    }

    try {
      await ApiService.addHostelMember(
        sid: student.sid.toString(),
        branch: branchCtrl.selectedBranch.value?.id.toString() ?? "",
        hostel: hostelId,
        floor: floorId,
        room: room, 
        month: month,
      );
      
      if (showSnackbar) {
        Get.snackbar("Success", "Hostel member added successfully");
      }
    } catch (e) {
      debugPrint("SAVE HOSTEL MEMBER ERROR: $e");
      if (showSnackbar) {
        Get.snackbar("Error", e.toString());
      }
    }
  }
}
