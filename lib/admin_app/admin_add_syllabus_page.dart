import 'package:flutter/material.dart';
import 'package:student_app/admin_app/admin_header.dart';

class AdminAddSyllabusPage extends StatefulWidget {
  const AdminAddSyllabusPage({super.key});

  @override
  State<AdminAddSyllabusPage> createState() => _AdminAddSyllabusPageState();
}

class _AdminAddSyllabusPageState extends State<AdminAddSyllabusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AdminHeader(title: "Add Syllabus"),

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
                  _buildDropdown("Select Branch"),
                  const SizedBox(height: 16),

                  _buildLabel("Group"),
                  _buildDropdown("Select Group"),
                  const SizedBox(height: 16),

                  _buildLabel("Course Name"),
                  _buildDropdown("Select Course"),
                  const SizedBox(height: 16),

                  _buildLabel("Batch"),
                  _buildDropdown("Select Batch"),
                  const SizedBox(height: 16),

                  _buildLabel("Select Subject"),
                  _buildDropdown("Select Subject"),
                  const SizedBox(height: 16),

                  _buildLabel("Chapter Name"),
                  _buildDropdown("Write Chapter Name"),
                  const SizedBox(height: 16),

                  _buildLabel("Expected Start Date"),
                  _buildDatePickerField("dd--mm--yy"),
                  const SizedBox(height: 16),

                  _buildLabel("Expected Accomplished Date"),
                  _buildDatePickerField("dd--mm--yy"),

                  const SizedBox(height: 30),

                  // Add to List Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFC184FC)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Add to List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: " *",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          items: [],
          onChanged: (val) {},
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const Icon(
            Icons.calendar_month_outlined,
            color: Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }
}
