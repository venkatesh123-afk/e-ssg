import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../api/api_collection.dart';
import 'manage_syllabus_controller.dart';

class AddEditSyllabusController extends GetxController {
  var isSaving = false.obs;

  Future<void> saveSingleSyllabus({
    required int examId,
    required int batchId,
    required int subjectId,
    required String syllabus,
  }) async {
    if (syllabus.isEmpty) {
      Get.snackbar("Warning", "Please enter syllabus details");
      return;
    }

    try {
      isSaving(true);
      final body = {
        "exam_id": examId,
        "batch_id": batchId,
        "subject_id": subjectId,
        "syllabus": syllabus,
      };

      final response = await ApiService.postRequest(ApiCollection.storeSingleExamSyllabus, body: body);

      final success = response['success'] == true || response['success'] == "true";
      
      if (success) {
        // Refresh the subject list in the previous screen if it exists
        if (Get.isRegistered<ManageSyllabusController>()) {
          Get.find<ManageSyllabusController>().fetchSubjectsList(examId, batchId);
        }
        
        Get.back();
        Get.snackbar(
          "Success",
          response['message'] ?? "Syllabus updated successfully",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to update syllabus");
      }
    } catch (e) {
      debugPrint("SAVE SINGLE SYLLABUS ERROR: $e");
      Get.snackbar("Error", "An error occurred while saving syllabus");
    } finally {
      isSaving(false);
    }
  }
}
