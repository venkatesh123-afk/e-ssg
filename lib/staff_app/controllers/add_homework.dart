import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';
import '../model/subject_model.dart';
import 'branch_controller.dart';
import 'group_controller.dart';
import 'course_controller.dart';
import 'batch_controller.dart';
import 'homework_controller.dart';
import '../utils/get_storage.dart';

class AddHomeworkController extends GetxController {
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final Rxn<SubjectModel> selectedSubject = Rxn<SubjectModel>();
  final RxBool isLoadingSubjects = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Clear selections when starting fresh
    resetSelections();

    // Load branches automatically
    if (branchCtrl.branches.isEmpty) {
      branchCtrl.loadBranches();
    }

    // Setup listeners for cascading effect (similar to AddSyllabusController)
    ever(branchCtrl.selectedBranch, (_) => _handleBranchChange());
    ever(groupCtrl.selectedGroup, (_) => _handleGroupChange());
    ever(courseCtrl.selectedCourse, (_) => _handleCourseChange());
    ever(batchCtrl.selectedBatch, (_) => _handleBatchChange());
  }

  void resetSelections() {
    selectedSubject.value = null;
    subjects.clear();
  }

  void _handleBranchChange() {
    final branch = branchCtrl.selectedBranch.value;
    groupCtrl.clear();
    courseCtrl.clear();
    batchCtrl.clear();
    resetSelections();
    if (branch != null) {
      groupCtrl.loadGroups(branch.id);
    }
  }

  void _handleGroupChange() {
    final group = groupCtrl.selectedGroup.value;
    courseCtrl.clear();
    batchCtrl.clear();
    resetSelections();
    if (group != null) {
      courseCtrl.loadCourses(group.id);
    }
  }

  void _handleCourseChange() {
    final course = courseCtrl.selectedCourse.value;
    batchCtrl.clear();
    resetSelections();
    if (course != null) {
      batchCtrl.loadBatches(course.id);
    }
  }

  void _handleBatchChange() {
    resetSelections();
    final batch = batchCtrl.selectedBatch.value;
    if (batch != null) {
      loadSubjects(batch.id);
    }
  }

  Future<void> loadSubjects(int batchId) async {
    try {
      isLoadingSubjects.value = true;
      subjects.clear();
      selectedSubject.value = null;

      final res = await ApiService.getRequest(
        ApiCollection.subjectsByBatch(batchId),
      );

      final success = res['success'] == true || res['success'] == "true";
      final dynamic rawData =
          res['indexdata'] ?? res['data'] ?? res['subjects'];

      if (success && rawData != null && rawData is List) {
        subjects.assignAll(
          rawData.map((e) => SubjectModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("SUBJECT API ERROR => $e");
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  Future<void> saveHomework() async {
    if (titleController.text.isEmpty ||
        branchCtrl.selectedBranch.value == null ||
        groupCtrl.selectedGroup.value == null ||
        courseCtrl.selectedCourse.value == null ||
        batchCtrl.selectedBatch.value == null ||
        selectedSubject.value == null ||
        descriptionController.text.isEmpty) {
      Get.snackbar(
        "Warning",
        "Please fill all required fields",
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    try {
      isSaving.value = true;

      final sid = AppStorage.getUserId();
      if (sid == null) {
        throw Exception("User session error. Please login again.");
      }

      await ApiService.saveHomework(
        sid: sid,
        title: titleController.text.trim(),
        branchId: branchCtrl.selectedBranch.value!.id,
        groupId: groupCtrl.selectedGroup.value!.id,
        courseId: courseCtrl.selectedCourse.value!.id,
        batchId: batchCtrl.selectedBatch.value!.id,
        subjectId: selectedSubject.value!.id,
        description: descriptionController.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Homework assigned successfully",
        backgroundColor: Colors.green.shade100,
      );

      // Refresh homework list if controller exists
      if (Get.isRegistered<HomeworkController>()) {
        Get.find<HomeworkController>().fetchHomework();
      }

      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
