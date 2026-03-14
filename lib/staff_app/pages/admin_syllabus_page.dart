import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';
import 'admin_add_syllabus_page.dart';
import '../controllers/syllabus_controller.dart';
import '../model/syllabus_model.dart';
import '../widgets/skeleton.dart';

class AdminSyllabusPage extends StatefulWidget {
  const AdminSyllabusPage({super.key});

  @override
  State<AdminSyllabusPage> createState() => _AdminSyllabusPageState();
}

class _AdminSyllabusPageState extends State<AdminSyllabusPage> {
  final SyllabusController controller = Get.put(SyllabusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: "Syllabus"),
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.5)),
                    ),
                    child: TextField(
                      onChanged: (value) => controller.searchQuery.value = value,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey, size: 20),
                        hintText: "Type a Keyword.....",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Card List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          itemBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: SkeletonLoader(height: 350, width: double.infinity),
                          ),
                        );
                      }
                      
                      final list = controller.filteredSyllabus;
                      
                      if (list.isEmpty) {
                        return const Center(
                          child: Text("No syllabus data found"),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildSyllabusCard(list[index], index + 1),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFC184FC)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminAddSyllabusPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Add Syllabus",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllabusCard(SyllabusModel item, int sNo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Divider(height: 20, color: Colors.grey),
          _buildInfoRow("Subject", item.subjectName ?? "N/A"),
          _buildInfoRow("Branch", item.branchName ?? "N/A"),
          _buildInfoRow("Group", item.groupName ?? "N/A"),
          _buildInfoRow("Course", item.courseName ?? "N/A"),
          _buildInfoRow("Batch", item.batchName ?? "N/A"),
          _buildInfoRow("Chapter", item.chapterName),
          
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Start date : ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.expectedStartDate, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Exp. date : ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.expectedAccomplishedDate, style: const TextStyle(color: Color(0xFFC62828), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Text("Progress : ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: item.progressPercent / 100,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("${item.progressPercent}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              const Text("Actions : ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    "Update",
                    "Update chapter: ${item.chapterName}",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.orange.shade900,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Colors.orange, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    "Delete",
                    "Syllabus for ${item.chapterName} deleted successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade900,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
