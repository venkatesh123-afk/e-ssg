import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../api/api_collection.dart';
import '../model/syllabus_batch_model.dart';

class SyllabusBatchController extends GetxController {
  var batchList = <SyllabusBatchModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  List<SyllabusBatchModel> get filteredBatches {
    if (searchQuery.isEmpty) return batchList;
    return batchList.where((b) {
      return b.batchName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             b.courseName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             b.groupName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             b.branchName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> fetchBatchList(int examId) async {
    try {
      isLoading(true);
      final response = await ApiService.getRequest(ApiCollection.examSyllabusBatches(examId));
      
      List rawData = [];
      if (response is List) {
        rawData = response;
      } else if (response is Map) {
        if (response['success'] == true || response['success'] == "true") {
          rawData = response['indexdata'] ?? response['data'] ?? [];
        }
      }

      if (rawData.isNotEmpty || (response is List && response.isEmpty)) {
        batchList.assignAll(rawData.map((e) => SyllabusBatchModel.fromMap(Map<String, dynamic>.from(e))).toList());
      }
    } catch (e) {
      debugPrint("FETCH SYLLABUS BATCHES ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}
