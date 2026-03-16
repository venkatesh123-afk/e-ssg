import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/controllers/edit_syllabus_controller.dart';
import 'package:student_app/staff_app/model/batch_model.dart';
import 'package:student_app/staff_app/model/subject_model.dart';
import 'package:student_app/staff_app/model/syllabus_model.dart';

class EditSyllabusPage extends StatefulWidget {
  final SyllabusModel? syllabus;
  const EditSyllabusPage({super.key, this.syllabus});

  @override
  State<EditSyllabusPage> createState() => _EditSyllabusPageState();
}

class _EditSyllabusPageState extends State<EditSyllabusPage> {
  late final TextEditingController chapterController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  final EditSyllabusController controller = Get.put(EditSyllabusController());

  String? subject;
  String? status;

  @override
  void initState() {
    super.initState();
    chapterController = TextEditingController(
      text: widget.syllabus?.chapterName ?? "",
    );
    startDateController = TextEditingController(
      text: widget.syllabus?.expectedStartDate ?? "",
    );
    endDateController = TextEditingController(
      text: widget.syllabus?.expectedAccomplishedDate ?? "",
    );

    status = (widget.syllabus?.status == 1 || widget.syllabus?.status == null)
        ? "Active"
        : "Inactive";

    // Prepopulate controllers with existing syllabus data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.prepopulate(widget.syllabus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// HEADER
          const AdminHeader(title: "Edit Syllabus"),

          const SizedBox(height: 15),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 40),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdown(
                      "Batch",
                      controller.batchCtrl.selectedBatch.value?.batchName,
                      controller.batchCtrl.batches
                          .map((BatchModel b) => b.batchName)
                          .whereType<String>()
                          .toList(),
                      (val) {
                        final batch = controller.batchCtrl.batches
                            .firstWhereOrNull(
                              (BatchModel b) => b.batchName == val,
                            );
                        controller.batchCtrl.selectedBatch.value = batch;
                      },
                      isLoading: controller.batchCtrl.isLoading.value,
                    ),

                    buildDropdown(
                      "Select Subject",
                      controller.selectedSubject.value?.subjectName,
                      controller.subjects
                          .map((SubjectModel s) => s.subjectName)
                          .whereType<String>()
                          .toList(),
                      (val) {
                        final subject = controller.subjects.firstWhereOrNull(
                          (SubjectModel s) => s.subjectName == val,
                        );
                        controller.selectedSubject.value = subject;
                      },
                      isLoading: controller.isLoadingSubjects.value,
                    ),

                    buildTextField("Chapter Name", chapterController),

                    buildDateField(
                      "Expected Start Date",
                      startDateController,
                      context,
                    ),

                    buildDateField(
                      "Expected Accomplished Date",
                      endDateController,
                      context,
                    ),

                    buildDropdown("Status", status, ["Active", "Inactive"], (
                      val,
                    ) {
                      setState(() => status = val);
                    }),

                    const SizedBox(height: 30),

                    /// UPDATE BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() {
                        return GestureDetector(
                          onTap: () {
                            if (widget.syllabus != null) {
                              controller.updateSyllabus(
                                id: widget.syllabus!.id,
                                chapterName: chapterController.text,
                                expectedStartDate: startDateController.text,
                                expectedAccomplishedDate:
                                    endDateController.text,
                                status: status ?? "Active",
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff7445F6),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xff7445F6,
                                  ).withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: controller.isUpdating.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Update Syllabus",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff6A5AE0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  /// READ ONLY FIELD
  Widget buildReadonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// TEXT FIELD
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// DATE FIELD
  Widget buildDateField(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => _selectDate(context, controller),
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xff6A5AE0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xff6A5AE0),
                        width: 1,
                      ),
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

  /// DROPDOWN
  Widget buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label == "Status"
              ? Text(label)
              : RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(color: Colors.black),
                    children: const [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: (items.contains(value)) ? value : null,
              decoration: InputDecoration(
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
