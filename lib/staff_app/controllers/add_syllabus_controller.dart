import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';
import 'syllabus_controller.dart';
import '../model/subject_model.dart';
import 'branch_controller.dart';
import 'group_controller.dart';
import 'course_controller.dart';
import 'batch_controller.dart';

class AddSyllabusController extends GetxController {
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());

  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final Rxn<SubjectModel> selectedSubject = Rxn<SubjectModel>();
  final RxBool isLoadingSubjects = false.obs;

  final RxBool isSaving = false.obs;

  // New fields for Syllabus
  final RxString chapterName = "".obs;
  final TextEditingController chapterNameController = TextEditingController();
  final Rxn<DateTime> expectedStartDate = Rxn<DateTime>();
  final Rxn<DateTime> expectedAccomplishedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    // Load branches if not already loaded
    if (branchCtrl.branches.isEmpty) {
      branchCtrl.loadBranches();
    }
    
    // Setup listeners for cascading effect
    ever(branchCtrl.selectedBranch, (branch) {
      groupCtrl.clear();
      courseCtrl.clear();
      batchCtrl.clear();
      clearSubjects();
      if (branch != null) {
        groupCtrl.loadGroups(branch.id);
      }
    });

    ever(groupCtrl.selectedGroup, (group) {
      courseCtrl.clear();
      batchCtrl.clear();
      clearSubjects();
      if (group != null) {
        courseCtrl.loadCourses(group.id);
      }
    });

    ever(courseCtrl.selectedCourse, (course) {
      batchCtrl.clear();
      clearSubjects();
      if (course != null) {
        batchCtrl.loadBatches(course.id);
      }
    });

    ever(batchCtrl.selectedBatch, (batch) {
      clearSubjects();
      if (batch != null) {
        loadSubjects(batch.id);
      }
    });
  }

  void resetForm() {
    branchCtrl.selectedBranch.value = null;
    groupCtrl.clear();
    courseCtrl.clear();
    batchCtrl.clear();
    clearSubjects();
    chapterName.value = "";
    chapterNameController.clear();
    expectedStartDate.value = null;
    expectedAccomplishedDate.value = null;
  }

  void clearSubjects() {
    subjects.clear();
    selectedSubject.value = null;
  }

  Future<void> loadSubjects(int batchId) async {
    try {
      isLoadingSubjects.value = true;
      subjects.clear();
      selectedSubject.value = null;

      final res = await ApiService.getRequest(ApiCollection.subjectsByBatch(batchId));

      final success = res['success'] == true || res['success'] == "true";
      final dynamic rawData = res['indexdata'] ?? res['data'] ?? res['subjects'];

      if (success && rawData != null && rawData is List) {
        subjects.assignAll(rawData.map((e) => SubjectModel.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint("SUBJECT API ERROR => $e");
      Get.snackbar("Error", "Failed to load subjects");
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  Future<void> saveSyllabus() async {
    if (branchCtrl.selectedBranch.value == null ||
        groupCtrl.selectedGroup.value == null ||
        courseCtrl.selectedCourse.value == null ||
        batchCtrl.selectedBatch.value == null ||
        selectedSubject.value == null ||
        chapterName.value.isEmpty ||
        expectedStartDate.value == null ||
        expectedAccomplishedDate.value == null) {
      Get.snackbar("Warning", "Please fill all required fields");
      return;
    }

    try {
      isSaving.value = true;
      
      final start = expectedStartDate.value!.toIso8601String().split('T')[0];
      final end = expectedAccomplishedDate.value!.toIso8601String().split('T')[0];

      final body = {
        "branchs": [branchCtrl.selectedBranch.value!.id],
        "groups": [groupCtrl.selectedGroup.value!.id],
        "courses": [courseCtrl.selectedCourse.value!.id],
        "batches": [batchCtrl.selectedBatch.value!.id],
        "subjects": [selectedSubject.value!.id],
        "chapters": [chapterName.value],
        "start_dates": [start],
        "accomplished_dates": [end],
      };

      final res = await ApiService.postRequest(ApiCollection.storeAcademicSyllabus, body: body);

      final success = res['success'] == true || res['success'] == "true" || res['success'] == 1;

      if (success) {
        if (Get.isRegistered<SyllabusController>()) {
          Get.find<SyllabusController>().fetchSyllabusList();
        }
        Get.back();
        Get.snackbar(
          "Success", 
          "Syllabus added successfully",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar("Error", res['message'] ?? "Failed to add syllabus");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save syllabus: $e");
    } finally {
      isSaving.value = false;
    }
  }
}
