import 'package:flutter/material.dart';
import '../widgets/staff_header.dart';
import '../model/admin_dashboard_attendance_model.dart';

class AttendanceSummaryPage extends StatelessWidget {
  final AttendanceClassSummary? summary;
  const AttendanceSummaryPage({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    // If no summary is passed, we could optionally show a message or find the first one from controller
    final shifts = summary?.shifts ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          StaffHeader(title: summary?.branchName ?? "Attendance Summary"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shifts.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text(
                          "No attendance data available for this branch.",
                        ),
                      ),
                    ),
                  ...shifts.values.map((shift) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: _buildAttendanceSection(
                        "${shift.shiftName ?? "Unknown"} Attendance",
                        shift,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSection(String title, AttendanceShift shift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10), // 0.04 opacity
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Table Header
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 2, child: _HeaderText("Type")),
                    Expanded(child: _HeaderText("Total")),
                    Expanded(child: _HeaderText("Present")),
                    Expanded(child: _HeaderText("Absent")),
                  ],
                ),
              ),
              // Day Row
              _buildDataRow(
                "Day",
                (shift.day?.total ?? 0).toString(),
                (shift.day?.present ?? 0).toString(),
                (shift.day?.absent ?? 0).toString(),
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
              // Hostel Row
              _buildDataRow(
                "Hostel",
                (shift.hostel?.total ?? 0).toString(),
                (shift.hostel?.present ?? 0).toString(),
                (shift.hostel?.absent ?? 0).toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(
    String type,
    String total,
    String present,
    String absent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              type,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              total,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              present,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              absent,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
