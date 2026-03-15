import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';

class HomeworkController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> homeworkList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomework();
  }

  Future<void> fetchHomework() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      homeworkList.clear();
      filteredList.clear();

      final res = await ApiService.getRequest(ApiCollection.homeworkList);

      if ((res['success'] == true || res['success'] == "true") && res['data'] != null) {
        final List data = res['data'];
        final List<Map<String, dynamic>> list = data.map((e) => Map<String, dynamic>.from(e)).toList();
        homeworkList.assignAll(list);
        filteredList.assignAll(list);
      } else {
        errorMessage.value = res['message'] ?? "No homework found";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("FETCH HOMEWORK ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchHomework(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(homeworkList);
    } else {
      final results = homeworkList.where((homework) {
        final title = homework['title']?.toString().toLowerCase() ?? '';
        final description = homework['description']?.toString().toLowerCase() ?? '';
        final creator = homework['creator']?['name']?.toString().toLowerCase() ?? '';
        
        return title.contains(query.toLowerCase()) || 
               description.contains(query.toLowerCase()) ||
               creator.contains(query.toLowerCase());
      }).toList();
      filteredList.assignAll(results);
    }
  }
}
