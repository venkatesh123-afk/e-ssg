import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../api/api_collection.dart';
import '../model/manage_syllabus_model.dart';

class ManageSyllabusController extends GetxController {
  var subjectList = <ManageSyllabusModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  List<ManageSyllabusModel> get filteredSubjects {
    if (searchQuery.isEmpty) return subjectList;
    return subjectList.where((s) {
      return s.subjectName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> fetchSubjectsList(int examId, int batchId) async {
    try {
      isLoading(true);
      final response = await ApiService.getRequest(ApiCollection.manageSyllabusSubjects(examId, batchId));
      
      List rawData = [];
      if (response is List) {
        rawData = response;
      } else if (response is Map) {
        if (response['success'] == true || response['success'] == "true") {
          rawData = response['indexdata'] ?? response['data'] ?? [];
        }
      }

      if (rawData.isNotEmpty || (response is List && response.isEmpty)) {
        subjectList.assignAll(rawData.map((e) => ManageSyllabusModel.fromMap(Map<String, dynamic>.from(e))).toList());
      }
    } catch (e) {
      debugPrint("FETCH MANAGE SYLLABUS SUBJECTS ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}
