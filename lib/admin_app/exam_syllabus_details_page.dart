import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/model/syllabus_model.dart';

class SyllabusDetailsPage extends StatelessWidget {
  const SyllabusDetailsPage({super.key, required SyllabusModel syllabus});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String subjectName = args['subjectName'] ?? 'N/A';
    final String examName = args['examName'] ?? 'N/A';
    final String batchName = args['batchName'] ?? 'N/A';
    final String courseName = args['courseName'] ?? 'N/A';
    final String branchName = args['branchName'] ?? 'N/A';
    final String groupName = args['groupName'] ?? 'N/A';
    final String syllabusContent = args['syllabusContent'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///  HEADER
          AdminHeader(title: "Syllabus Details", onBack: () => Get.back()),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SUBJECT TITLE
                  Text(
                    subjectName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// DETAILS CARD
                  Container(
                    width: double.infinity,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("Exam Name", examName),
                        const SizedBox(height: 8),

                        _buildRow("Batch/Course", "$batchName / $courseName"),
                        const SizedBox(height: 8),

                        _buildRow("Branch", branchName),
                        const SizedBox(height: 8),

                        _buildRow("Group", groupName),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SUBJECT SYLLABUS TITLE
                  const Text(
                    "Subject Syllabus",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// SYLLABUS BOX
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        syllabusContent.isEmpty
                            ? "No syllabus content added yet."
                            : syllabusContent,
                        style: const TextStyle(color: Colors.black87),
                      ),
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

  /// DETAILS ROW
  Widget _buildRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            "$title :",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0A66FF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
