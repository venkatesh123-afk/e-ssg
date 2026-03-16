import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/controllers/add_edit_syllabus.dart';

class AddEditSyllabusPage extends StatefulWidget {
  const AddEditSyllabusPage({super.key});

  @override
  State<AddEditSyllabusPage> createState() => _AddEditSyllabusPageState();
}

class _AddEditSyllabusPageState extends State<AddEditSyllabusPage> {
  final AddEditSyllabusController controller = Get.put(
    AddEditSyllabusController(),
  );
  final TextEditingController _syllabusController = TextEditingController();

  late final int examId;
  late final int batchId;
  late final int subjectId;
  late final String subjectName;
  late final String initialSyllabus;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    examId = args['examId'] ?? 0;
    batchId = args['batchId'] ?? 0;
    subjectId = args['subjectId'] ?? 0;
    subjectName = args['subjectName'] ?? '';
    initialSyllabus = args['syllabus'] ?? '';
    _syllabusController.text = initialSyllabus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          AdminHeader(
            title: "Add/Edit Syllabus - $subjectName",
            onBack: () => Get.back(),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LABEL
                  const Text(
                    "Syllabus Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  /// TEXT AREA
                  Container(
                    height: 160,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextField(
                      controller: _syllabusController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: "Enter syllabus details here.....",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// SAVE BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : () => controller.saveSingleSyllabus(
                                examId: examId,
                                batchId: batchId,
                                subjectId: subjectId,
                                syllabus: _syllabusController.text,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B5CFF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Save Syllabus",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
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
}
