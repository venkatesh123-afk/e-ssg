import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xffE6DFF3),
                borderRadius: BorderRadius.circular(25),
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
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black54),
                        hintText: "Type a Keyword.....",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ASSIGNMENT CARD
                  Container(
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
                        const Text(
                          "S.NO: 1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const Divider(),

                        const Text("Title :  -----"),
                        const Text("Created By :  -------"),
                        const Text("Created At :  -----"),

                        const SizedBox(height: 10),

                        /// ACTION BUTTONS
                        Row(
                          children: [
                            const Text(
                              "Actions : ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                                size: 18,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

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
}
