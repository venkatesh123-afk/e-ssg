import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';
import '../controllers/homework_controller.dart';
import 'package:intl/intl.dart';

class AssignmentsPage extends StatelessWidget {
  AssignmentsPage({super.key});

  final HomeworkController controller = Get.put(HomeworkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          /// HEADER
          const StaffHeader(title: "Assignments"),

          const SizedBox(height: 20),

          /// MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffE6DFF3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    /// SEARCH BAR
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.deepPurple),
                        color: Colors.white,
                      ),
                      child: TextField(
                        onChanged: (value) => controller.searchHomework(value),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          hintText: "Type a Keyword.....",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ASSIGNMENT LIST
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.errorMessage.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.errorMessage.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => controller.fetchHomework(),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          );
                        }

                        if (controller.filteredList.isEmpty) {
                          return const Center(child: Text("No assignments found"));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: controller.filteredList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final homework = controller.filteredList[index];
                            final createdAt = homework['created_at'] != null 
                                ? DateFormat('dd-MM-yyyy').format(DateTime.parse(homework['created_at']))
                                : '-----';

                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.black12,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "S.NO: ${index + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Divider(),
                                  _buildInfoRow("Title", homework['title'] ?? '-----'),
                                  _buildInfoRow("Created By", homework['creator']?['name'] ?? '-------'),
                                  _buildInfoRow("Created At", createdAt),
                                  const SizedBox(height: 10),

                                  /// ACTION BUTTONS
                                  Row(
                                    children: [
                                      const Text(
                                        "Actions : ",
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(width: 10),
                                      _buildActionButton(Icons.edit, Colors.orange),
                                      const SizedBox(width: 10),
                                      _buildActionButton(Icons.delete, Colors.red),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ADD ASSIGNMENT BUTTON
          GestureDetector(
            onTap: () => Get.toNamed('/addAssignments'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6A5AE0), Color(0xffB06AB3)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Add Assignments",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label : ",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }
}
