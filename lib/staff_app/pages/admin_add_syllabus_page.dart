import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widgets/staff_header.dart';
import '../controllers/add_syllabus_controller.dart';

class AdminAddSyllabusPage extends StatefulWidget {
  const AdminAddSyllabusPage({super.key});

  @override
  State<AdminAddSyllabusPage> createState() => _AdminAddSyllabusPageState();
}

class _AdminAddSyllabusPageState extends State<AdminAddSyllabusPage> {
  // Initialize all controllers
  final AddSyllabusController controller = Get.put(AddSyllabusController());

  @override
  void initState() {
    super.initState();
    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StaffHeader(title: "Add Syllabus"),
            
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Branch"),
                  Obx(() => _buildDropdown<int>(
                    hint: "Select Branch",
                    value: controller.branchCtrl.selectedBranch.value?.id,
                    items: controller.branchCtrl.branches.map((b) => DropdownMenuItem(
                      value: b.id,
                      child: Text(b.branchName),
                    )).toList(),
                    onChanged: (val) {
                      controller.branchCtrl.selectedBranch.value = controller.branchCtrl.branches.firstWhere((b) => b.id == val);
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Group"),
                  Obx(() => _buildDropdown<int>(
                    hint: "Select Group",
                    value: controller.groupCtrl.selectedGroup.value?.id,
                    items: controller.groupCtrl.groups.map((g) => DropdownMenuItem(
                      value: g.id,
                      child: Text(g.name),
                    )).toList(),
                    onChanged: (val) {
                      controller.groupCtrl.selectedGroup.value = controller.groupCtrl.groups.firstWhere((g) => g.id == val);
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Course Name"),
                  Obx(() => _buildDropdown<int>(
                    hint: "Select Course",
                    value: controller.courseCtrl.selectedCourse.value?.id,
                    items: controller.courseCtrl.courses.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.courseName),
                    )).toList(),
                    onChanged: (val) {
                      controller.courseCtrl.selectedCourse.value = controller.courseCtrl.courses.firstWhere((c) => c.id == val);
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Batch"),
                  Obx(() => _buildDropdown<int>(
                    hint: "Select Batch",
                    value: controller.batchCtrl.selectedBatch.value?.id,
                    items: controller.batchCtrl.batches.map((b) => DropdownMenuItem(
                      value: b.id,
                      child: Text(b.batchName),
                    )).toList(),
                    onChanged: (val) {
                      controller.batchCtrl.selectedBatch.value = controller.batchCtrl.batches.firstWhere((b) => b.id == val);
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Select Subject"),
                  Obx(() => _buildDropdown<int>(
                    hint: "Select Subject",
                    value: controller.selectedSubject.value?.id,
                    items: controller.subjects.map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(s.subjectName),
                    )).toList(),
                    onChanged: (val) {
                      controller.selectedSubject.value = controller.subjects.firstWhere((s) => s.id == val);
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Chapter Name"),
                  _buildTextField("Write Chapter Name", controller.chapterNameController, (val) {
                    controller.chapterName.value = val;
                  }),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Expected Start Date"),
                  Obx(() => _buildDatePickerField(
                    controller.expectedStartDate.value == null 
                      ? "dd--mm--yy" 
                      : DateFormat('dd-MM-yyyy').format(controller.expectedStartDate.value!),
                    () => _selectDate(context, true),
                  )),
                  const SizedBox(height: 16),
                  
                  _buildLabel("Expected Accomplished Date"),
                  Obx(() => _buildDatePickerField(
                    controller.expectedAccomplishedDate.value == null 
                      ? "dd--mm--yy" 
                      : DateFormat('dd-MM-yyyy').format(controller.expectedAccomplishedDate.value!),
                    () => _selectDate(context, false),
                  )),
                  
                  const SizedBox(height: 30),
                  
                  // Add to List Button
                  Obx(() => Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: controller.isSaving.value 
                          ? [Colors.grey, Colors.grey]
                          : [const Color(0xFF8B5CF6), const Color(0xFFC184FC)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value ? null : () => controller.saveSyllabus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: controller.isSaving.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add to List",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController textController, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          value: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(color: Colors.black54, fontSize: 14)),
            const Icon(Icons.calendar_month_outlined, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8B5CF6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
        controller.expectedStartDate.value = picked;
      } else {
        controller.expectedAccomplishedDate.value = picked;
      }
    }
  }
}
