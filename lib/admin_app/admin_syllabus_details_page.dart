import 'package:flutter/material.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/model/syllabus_model.dart';

class SyllabusDetailsPage extends StatelessWidget {
  final SyllabusModel syllabus;
  const SyllabusDetailsPage({super.key, required this.syllabus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// HEADER
          const AdminHeader(title: "Syllabus Details"),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xffE6DFF3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow("Branch", syllabus.branchName ?? "N/A"),
                    buildRow("Group", syllabus.groupName ?? "N/A"),
                    buildRow("Course", syllabus.courseName ?? "N/A"),
                    buildRow("Batch", syllabus.batchName ?? "N/A"),
                    buildRow("Subject", syllabus.subjectName ?? "N/A"),
                    buildRow("Chapter Name", syllabus.chapterName),
                    buildRow("Expected Start Date", syllabus.expectedStartDate),
                    buildRow(
                      "Expected Accomplished Date",
                      syllabus.expectedAccomplishedDate,
                    ),
                    buildRow(
                      "Actual Start Date",
                      syllabus.actualStartDate ?? "-",
                    ),
                    buildRow(
                      "Actual Completion Date",
                      syllabus.actualCompletedDate ?? "-",
                    ),

                    const SizedBox(height: 8),

                    /// PROGRESS
                    Row(
                      children: [
                        const Text("Progress : "),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: syllabus.progressPercent / 100,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation(
                                  syllabus.progressPercent < 50
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Text("${syllabus.progressPercent}%"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// TRACKING STATUS
                    Row(
                      children: [
                        const Text("Tracking Status : "),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTrackingStatusColor(
                              syllabus.trackingStatus,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            syllabus.trackingRemarks ?? "N/A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// STATUS
                    Row(
                      children: [
                        const Text("Status : "),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: syllabus.status == 1
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            syllabus.status == 1 ? "Active" : "Inactive",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrackingStatusColor(int? status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
