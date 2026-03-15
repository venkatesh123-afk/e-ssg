import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import 'syllabus_controller.dart';
import 'branch_controller.dart';
import 'group_controller.dart';
import 'course_controller.dart';
import 'batch_controller.dart';
import '../model/syllabus_model.dart';
import '../model/subject_model.dart';

class EditSyllabusController extends GetxController {
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());

  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final Rxn<SubjectModel> selectedSubject = Rxn<SubjectModel>();
  final RxBool isLoadingSubjects = false.obs;
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Setup listeners for cascading effect
    ever(branchCtrl.selectedBranch, (_) => _handleBranchChange());
    ever(groupCtrl.selectedGroup, (_) => _handleGroupChange());
    ever(courseCtrl.selectedCourse, (_) => _handleCourseChange());
    ever(batchCtrl.selectedBatch, (_) => _handleBatchChange());
  }

  void _handleBranchChange() {
    final branch = branchCtrl.selectedBranch.value;
    if (branch != null) {
      groupCtrl.loadGroups(branch.id);
    } else {
      groupCtrl.clear();
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

  void _handleBatchChange() {
    final batch = batchCtrl.selectedBatch.value;
    if (batch != null) {
      loadSubjects(batch.id);
    } else {
      subjects.clear();
      selectedSubject.value = null;
    }
  }

  Future<void> loadSubjects(int batchId) async {
    try {
      isLoadingSubjects.value = true;
      subjects.clear();
      selectedSubject.value = null;

      final data = await ApiService.getSubjectsByBatch(batchId);
      subjects.assignAll(data.map((e) => SubjectModel.fromJson(e)).toList());
    } catch (e) {
      debugPrint("SUBJECT API ERROR => $e");
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  void prepopulate(SyllabusModel? syllabus) async {
    if (syllabus == null) return;

    // Load branches if not loaded
    if (branchCtrl.branches.isEmpty) {
      await branchCtrl.loadBranches();
    }

    // Find and set branch
    final branch = branchCtrl.branches.firstWhereOrNull(
      (b) => b.id == syllabus.branchId,
    );
    
    if (branch != null) {
      branchCtrl.selectedBranch.value = branch;
      
      // Cascading loads are handled by 'ever' listeners, 
      // but they are async. For prepopulation, we manually wait to ensure sequence.
      
      await groupCtrl.loadGroups(syllabus.branchId);
      final group = groupCtrl.groups.firstWhereOrNull(
        (g) => g.id == syllabus.groupId,
      );
      if (group != null) {
        groupCtrl.selectedGroup.value = group;

        await courseCtrl.loadCourses(syllabus.groupId);
        final course = courseCtrl.courses.firstWhereOrNull(
          (c) => c.id == syllabus.courseId,
        );
        if (course != null) {
          courseCtrl.selectedCourse.value = course;

          await batchCtrl.loadBatches(syllabus.courseId);
          final batch = batchCtrl.batches.firstWhereOrNull(
            (b) => b.id == syllabus.batchId,
          );
          if (batch != null) {
            batchCtrl.selectedBatch.value = batch;

            await loadSubjects(syllabus.batchId);
            selectedSubject.value = subjects.firstWhereOrNull(
              (s) => s.id == syllabus.subjectId,
            );
          }
        }
      }
    }
  }

  Future<void> updateSyllabus({
    required int id,
    required String chapterName,
    required String expectedStartDate,
    required String expectedAccomplishedDate,
    required String status,
  }) async {
    if (chapterName.isEmpty) {
      Get.snackbar("Warning", "Chapter Name is required");
      return;
    }

    if (branchCtrl.selectedBranch.value == null ||
        batchCtrl.selectedBatch.value == null ||
        selectedSubject.value == null) {
      Get.snackbar("Warning", "Please select Branch, Batch and Subject");
      return;
    }

    try {
      isUpdating(true);
      
      int statusId = (status == "Active") ? 1 : 0;
      
      String formattedStart = _formatDateForApi(expectedStartDate);
      String formattedEnd = _formatDateForApi(expectedAccomplishedDate);

      await ApiService.updateAcademicSyllabus(
        id: id,
        chapterName: chapterName,
        expectedStartDate: formattedStart,
        expectedAccomplishedDate: formattedEnd,
        status: statusId,
        branchId: branchCtrl.selectedBranch.value?.id,
        groupId: groupCtrl.selectedGroup.value?.id,
        courseId: courseCtrl.selectedCourse.value?.id,
        batchId: batchCtrl.selectedBatch.value?.id,
        subjectId: selectedSubject.value?.id,
      );

      if (Get.isRegistered<SyllabusController>()) {
        Get.find<SyllabusController>().fetchSyllabusList();
      }

      Get.back();
      Get.snackbar(
        "Success",
        "Syllabus updated successfully",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      debugPrint("UPDATE SYLLABUS ERROR: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isUpdating(false);
    }
  }

  String _formatDateForApi(String date) {
    if (date.contains('-')) {
      List<String> parts = date.split('-');
      if (parts[0].length == 4) return date; // Already YYYY-MM-DD
      if (parts.length == 3) {
        return "${parts[2]}-${parts[1]}-${parts[0]}"; // DD-MM-YYYY to YYYY-MM-DD
      }
    }
    return date;
  }
}
