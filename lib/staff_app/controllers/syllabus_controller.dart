import 'package:get/get.dart';
import '../api/api_service.dart';
import '../api/api_collection.dart';
import '../model/syllabus_model.dart';
import 'package:flutter/material.dart';

class SyllabusController extends GetxController {
  var syllabusList = <SyllabusModel>[].obs;
  var isLoading = false.obs;

  var searchQuery = ''.obs;

  List<SyllabusModel> get filteredSyllabus {
    if (searchQuery.isEmpty) return syllabusList;
    return syllabusList.where((s) {
      return s.chapterName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSyllabusList();
  }

  Future<void> fetchSyllabusList() async {
    try {
      isLoading(true);
      final response = await ApiService.getRequest(ApiCollection.academicSyllabusList);
      
      List rawData = [];
      if (response is List) {
        rawData = response;
      } else if (response is Map) {
        if (response['success'] == "true" || response['success'] == true || response['success'] == 1) {
          rawData = response['indexdata'] ?? response['data'] ?? [];
        } else {
          String msg = response['message'] ?? "Failed to fetch syllabus";
          debugPrint("API ERROR: $msg");
        }
      }

      if (rawData.isNotEmpty || (response is List && response.isEmpty)) {
        final List<SyllabusModel> allItems = rawData.map((e) => SyllabusModel.fromMap(Map<String, dynamic>.from(e))).toList();
        
        // Deduplication logic: Group by Batch + Subject + Chapter
        final Map<String, SyllabusModel> uniqueItems = {};
        for (var item in allItems) {
          final key = "${item.batchId}_${item.subjectId}_${item.chapterName.toLowerCase().trim()}";
          
          if (!uniqueItems.containsKey(key) || (item.progressPercent > uniqueItems[key]!.progressPercent)) {
            uniqueItems[key] = item;
          }
        }
        
        syllabusList.assignAll(uniqueItems.values.toList());
      }
    } catch (e) {
      debugPrint("FETCH SYLLABUS ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}
