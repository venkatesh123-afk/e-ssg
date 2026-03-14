import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'syllabus_details_page.dart';
import 'add_edit_syllabus_page.dart';
import '../widgets/staff_header.dart';
import '../controllers/manage_syllabus_controller.dart';
import '../model/syllabus_batch_model.dart';
import '../widgets/skeleton.dart';

class ManageSyllabusPage extends StatefulWidget {
  const ManageSyllabusPage({super.key});

  @override
  State<ManageSyllabusPage> createState() => _ManageSyllabusPageState();
}

class _ManageSyllabusPageState extends State<ManageSyllabusPage> {
  final ManageSyllabusController controller = Get.put(ManageSyllabusController());
  final TextEditingController _searchController = TextEditingController();

  late final SyllabusBatchModel batch;
  late final String examName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      batch = args['batch'];
      examName = args['examName'] ?? '';
    } else {
      // Fallback or error handling
      batch = args as SyllabusBatchModel;
      examName = '';
    }
    controller.fetchSubjectsList(batch.examId, batch.batchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          StaffHeader(
            title: "Manage Syllabus",
            onBack: () => Get.back(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Summary",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _summaryRow("Exam", examName),
                        _summaryRow("Branch", batch.branchName),
                        _summaryRow("Batch", batch.batchName),
                        _summaryRow("Course", batch.courseName),
                        _summaryRow("Group", batch.groupName),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE6F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF7B5CFF)),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => controller.searchQuery.value = value,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.black54),
                              hintText: "Type a Keyword.....",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: StaffLoadingAnimation());
                          }
                          if (controller.filteredSubjects.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No subjects found"),
                              ),
                            );
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredSubjects.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 15),
                            itemBuilder: (context, index) {
                              final subject = controller.filteredSubjects[index];
                              return _buildSubjectCard(index + 1, subject);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(int sNo, dynamic subject) {
    final bool hasSyllabus = subject.hasSyllabus;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _infoRowItem("Subject", subject.subjectName),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                "Status : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: hasSyllabus ? const Color(0xFFE2F3E7) : const Color(0xFFFFF2DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasSyllabus ? "Added" : "Not Added",
                  style: TextStyle(
                    color: hasSyllabus ? const Color(0xFF2E7D32) : Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Actions : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Get.to(() => const AddEditSyllabusPage(), arguments: {
                  'examId': batch.examId,
                  'batchId': batch.batchId,
                  'subjectId': subject.id,
                  'subjectName': subject.subjectName,
                  'syllabus': subject.syllabus,
                }),
                child: const Icon(Icons.edit, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () => Get.to(() => const SyllabusDetailsPage(), arguments: {
                  'subjectName': subject.subjectName,
                  'examName': examName,
                  'batchName': batch.batchName,
                  'courseName': batch.courseName,
                  'branchName': batch.branchName,
                  'groupName': batch.groupName,
                  'syllabusContent': subject.syllabus,
                }),
                child: const Icon(Icons.menu_book, color: Colors.indigo, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$title :",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _infoRowItem(String title, String value) {
    return Row(
      children: [
        Text("$title : ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
