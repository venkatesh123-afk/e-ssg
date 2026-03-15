import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:student_app/staff_app/pages/attendance_summary_page.dart';
import 'package:student_app/staff_app/pages/staff_dashboard_page.dart';
import 'admin_student_search_page.dart';

import '../utils/iconify_icons.dart';

import 'admin_syllabus_page.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../model/admin_dashboard_finance_model.dart';
import '../model/admin_dashboard_attendance_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AdminDashboardController controller = Get.put(
    AdminDashboardController(),
  );
  String _activeTab = "Admissions";
  String _activeFeeTab = "Todays";
  String _activeExpenseTab = "Todays";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B5CF6), // Primary Purple
              Color(0xFFC084FC), // Lighter Purple
              Colors.white, // Bottom White
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // App Bar Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(
                            0xFFB388FF,
                          ), // Lighter Purple as in image 2
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_open,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildHeaderIcon(Icons.search),
                        const SizedBox(width: 10),
                        _buildHeaderIcon(
                          Icons.notifications_none,
                          hasBadge: true,
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Title and Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Super Admin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "2025-26",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        "Admissions",
                        _activeTab == "Admissions",
                        icon: Icons.person_outline,
                        onTap: () {
                          setState(() => _activeTab = "Admissions");
                          controller.fetchAdmissionsData();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton(
                        "Finance",
                        _activeTab == "Finance",
                        icon: Icons.account_balance_wallet_outlined,
                        onTap: () {
                          setState(() => _activeTab = "Finance");
                          controller.fetchFinanceData();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton(
                        "Attendance",
                        _activeTab == "Attendance",
                        icon: Icons.person_add_alt_1_outlined,
                        onTap: () {
                          setState(() => _activeTab = "Attendance");
                          controller.fetchAttendanceData();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                if (_activeTab == "Admissions") _buildAdmissionsBody(),
                if (_activeTab == "Attendance") _buildAttendanceBody(),
                if (_activeTab == "Finance") _buildFinanceBody(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAdmissionsBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => controller.fetchAdmissionsData(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      final info = controller.admissionsData.value.infodata;
      if (info == null) {
        return const Center(
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Grid
          _buildStatsGrid(),
          const SizedBox(height: 25),
          // Charts Section
          _buildChartCard(
            "Total Strength Male/Female",
            _buildDonutChart(
              sections: [
                PieChartSectionData(
                  value: (info.girlsStudentsCount ?? 0).toDouble(),
                  color: const Color(0xFF5C6BC0),
                  title:
                      '${((info.girlsStudentsCount ?? 0) / (info.totalStudentsCount ?? 1) * 100).toStringAsFixed(1)}%',
                  radius: 20,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.7,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                PieChartSectionData(
                  value: (info.boysStudentsCount ?? 0).toDouble(),
                  color: const Color(0xFF26A69A),
                  title:
                      '${((info.boysStudentsCount ?? 0) / (info.totalStudentsCount ?? 1) * 100).toStringAsFixed(1)}%',
                  radius: 20,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.7,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
              legends: [
                {"label": "Girls", "color": const Color(0xFF5C6BC0)},
                {"label": "Boys", "color": const Color(0xFF26A69A)},
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildChartCard(
            "Total Strength Hostel/Day",
            _buildDonutChart(
              sections: [
                PieChartSectionData(
                  value: (info.dayStudentsCount ?? 0).toDouble(),
                  color: const Color(0xFFEF5350),
                  title:
                      '${((info.dayStudentsCount ?? 0) / (info.totalStudentsCount ?? 1) * 100).toStringAsFixed(1)}%',
                  radius: 20,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.7,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                PieChartSectionData(
                  value: (info.hostelStudentsCount ?? 0).toDouble(),
                  color: const Color(0xFF42A5F5),
                  title:
                      '${((info.hostelStudentsCount ?? 0) / (info.totalStudentsCount ?? 1) * 100).toStringAsFixed(1)}%',
                  radius: 20,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.7,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
              legends: [
                {"label": "Day", "color": const Color(0xFFEF5350)},
                {"label": "Hostel", "color": const Color(0xFF42A5F5)},
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Branch Wise Chart
          _buildChartCard("Total Students Branch Wise", _buildBranchPieChart()),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              "Total Students Data Branch Wise",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          // Branch Data List
          _buildBranchDataList(),
        ],
      );
    });
  }

  Widget _buildAttendanceBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      final info = controller.attendanceData.value.infodata;
      if (info == null) {
        return const Center(
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceStatsGrid(info),
          const SizedBox(height: 25),
          const Text(
            "Student Attendance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildProgressCard(
            const Color(0xFF7E57C2),
            info.studentAttendanceCount ?? 0,
          ),
          const SizedBox(height: 25),
          const Text(
            "Staff Attendance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildProgressCard(
            const Color(0xFF2196F3),
            info.staffAttendanceCount ?? 0,
          ),
          const SizedBox(height: 25),
          _buildTodaysAttendanceInfo(info),
          const SizedBox(height: 25),
          _buildClassWiseSummary(info),
        ],
      );
    });
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        if (hasBadge)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabButton(
    String label,
    bool isActive, {
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7E57C2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.black87,
                size: 16,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatsGrid(AttendanceInfodata info) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Todays Outing",
                (info.totalTodaysOutingCount ?? 0).toString(),
                IconifyIcons.account,
                [const Color(0xFF4DE1B0), const Color(0xFF00BFA5)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Home Pass",
                (info.totalTodaysHomepassOutingCount ?? 0).toString(),
                IconifyIcons.hugeIconsBus03,
                [const Color(0xFFF1597E), const Color(0xFFD81B60)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Out Pass",
                (info.totalTodaysOutpassOutingCount ?? 0).toString(),
                IconifyIcons.clarityBuildingLine,
                [const Color(0xFFFFB755), const Color(0xFFFB8C00)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Self Pass",
                (info.totalTodaysSelfpassOutingCount ?? 0).toString(),
                IconifyIcons.account,
                [const Color(0xFF46B1FF), const Color(0xFF1E88E5)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Staff",
                (info.staffCount ?? 0).toString(),
                IconifyIcons.account,
                [const Color(0xFF4EE298), const Color(0xFF43A047)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Student Attendance",
                (info.studentAttendanceCount ?? 0).toString(),
                IconifyIcons.account,
                [const Color(0xFFF1597E), const Color(0xFFD81B60)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Staff Attendance",
                (info.staffAttendanceCount ?? 0).toString(),
                IconifyIcons.phStudent,
                [const Color(0xFF6B7AF5), const Color(0xFF5C6BC0)],
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(Color color, int count) {
    final List<String> branches = [
      "Pelluru",
      "VRB",
      "PVB",
      "Vidya Bhavan",
      "Padmavathi",
      "MM Road",
      "AVP",
      "Tallur",
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4),
        ],
      ),
      child: Column(
        children: branches
            .map(
              (branch) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        branch,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: 0.75, // Static 75% as requested
                          backgroundColor: color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "75%",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTodaysAttendanceInfo(AttendanceInfodata info) {
    return _buildChartCard(
      "Todays Attendance Info",
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "S.NO: 1",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Branch :",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Total",
                  (info.studentAttendanceCount ?? 0).toString(),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  "Present",
                  (info.studentAttendanceCount ?? 0).toString(),
                ), // Assuming Present = Total for now if no specific "present" field exists at top level
                const SizedBox(height: 8),
                _buildInfoRow("Absent", "0"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total : ${info.studentAttendanceCount ?? 0}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.white30, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total : ${info.studentAttendanceCount ?? 0}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Present : ${info.studentAttendanceCount ?? 0}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      "Absent : 0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          ": $value",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildClassWiseSummary(AttendanceInfodata info) {
    return _buildChartCard(
      "Class Wise Student Attendance Summary",
      Column(
        children: (info.classAttendanceSummary ?? [])
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildClassCard(entry.value, entry.key + 1),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildClassCard(AttendanceClassSummary summary, int sNo) {
    return Container(
      width: 326, // FIXED WIDTH
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                "Branch : ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  summary.branchName ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),
          // Loop through shifts if needed, but summary card shows Day/Hostel for first shift usually or aggregate
          // Based on the provided summary design, we show stats.
          // Let's take the first shift or aggregate if possible.
          if (summary.shifts != null && summary.shifts!.isNotEmpty) ...[
            const Text(
              "Day Students",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSimpleStat(
                    "Total",
                    (summary.shifts!.values.first.day?.total ?? 0).toString(),
                    const Color(0xFF9575CD),
                    Icons.group,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSimpleStat(
                    "Present",
                    (summary.shifts!.values.first.day?.present ?? 0).toString(),
                    const Color(0xFF4DB6AC),
                    Icons.person,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSimpleStat(
                    "Absent",
                    (summary.shifts!.values.first.day?.absent ?? 0).toString(),
                    const Color(0xFFEF5350),
                    Icons.person_off,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Hostel Students",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSimpleStat(
                    "Total",
                    (summary.shifts!.values.first.hostel?.total ?? 0)
                        .toString(),
                    const Color(0xFF42A5F5),
                    Icons.hotel,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSimpleStat(
                    "Present",
                    (summary.shifts!.values.first.hostel?.present ?? 0)
                        .toString(),
                    const Color(0xFF66BB6A),
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSimpleStat(
                    "Absent",
                    (summary.shifts!.values.first.hostel?.absent ?? 0)
                        .toString(),
                    const Color(0xFFFF7043),
                    Icons.cancel,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceSummaryPage(summary: summary),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7E57C2),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(100, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text(
              "View Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 12, color: color),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final info = controller.admissionsData.value.infodata;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Students",
                "${info?.totalStudentsCount ?? 0}",
                IconifyIcons.phStudent,
                [const Color(0xFF6B7AF5), const Color(0xFF5C6BC0)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Boys",
                "${info?.boysStudentsCount ?? 0}",
                IconifyIcons.account,
                [const Color(0xFFFFB755), const Color(0xFFFB8C00)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Girls",
                "${info?.girlsStudentsCount ?? 0}",
                IconifyIcons.account,
                [const Color(0xFF4EE298), const Color(0xFF43A047)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Day",
                "${info?.dayStudentsCount ?? 0}",
                IconifyIcons.hugeIconsBus03,
                [const Color(0xFF46B1FF), const Color(0xFF1E88E5)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Hostel",
                "${info?.hostelStudentsCount ?? 0}",
                IconifyIcons.clarityBuildingLine,
                [const Color(0xFFF1597E), const Color(0xFFD81B60)],
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String iconData,
    List<Color> colors,
  ) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -20,
            left: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Iconify(iconData, color: Colors.white, size: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE9EBFF), // Precise lavender header color
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: chart),
        ],
      ),
    );
  }

  Widget _buildDonutChart({
    required List<PieChartSectionData> sections,
    required List<Map<String, dynamic>> legends,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 234, // Exact spec from image
          height: 156, // Exact spec from image
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 50,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: legends
              .map(
                (l) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 15, // Specification: dot size increase
                        height: 15,
                        decoration: BoxDecoration(
                          color: l['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l['label'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBranchPieChart() {
    final info = controller.admissionsData.value.infodata;
    final branchList = info?.totalBranchInfo ?? [];
    final totalStudents = info?.totalStudentsCount ?? 1;

    final List<Color> branchColors = [
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.yellow.shade700,
      Colors.red,
      Colors.lightGreen,
      Colors.green.shade700,
      Colors.teal,
    ];

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: branchList.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.5),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: branchColors[entry.key % branchColors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value.branchName ?? "",
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 141, // Exact spec from image
              height: 141, // Exact spec from image
              child: PieChart(
                PieChartData(
                  sections: branchList.asMap().entries.map((entry) {
                    return PieChartSectionData(
                      value: (entry.value.total ?? 0).toDouble(),
                      color: branchColors[entry.key % branchColors.length],
                      title:
                          '${((entry.value.total ?? 0) / totalStudents * 100).toStringAsFixed(1)}%',
                      radius: 70.5, // 141 / 2
                      showTitle: true,
                      titleStyle: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchDataList() {
    final info = controller.admissionsData.value.infodata;
    final branchList = info?.totalBranchInfo ?? [];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: branchList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = branchList[index];
          return Container(
            padding: const EdgeInsets.all(12),
            height: 107, // Specification: Height: 107px
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16,
              ), // Specification: Radius: 16px
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.25,
                  ), // Specification: BoxShadow: 25% opacity
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "S.NO: ${index + 1}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Row(
                  children: [
                    const Text(
                      "Branch : ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.branchName ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Count : ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      item.total.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF8F7FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 60, 20, 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B7AF5), Color(0xFFB388FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "Logo",
                      style: TextStyle(
                        color: Color(0xFF6B7AF5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Ashok Reddy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "User ID :  667021",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              children: [
                _buildDrawerItem(
                  Icons.grid_view_outlined,
                  "Staff Dashboard",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeDashboardPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  Icons.how_to_reg_outlined,
                  "Pro Admission",
                  onTap: () => Get.toNamed('/adminAdmission'),
                ),
                _buildDrawerItem(
                  Icons.person_pin_outlined,
                  "Attendance",
                  hasDropdown: true,
                  children: [
                    _buildDrawerSubItem(
                      "Class Attendence",
                      () => Get.toNamed('/classAttendance'),
                    ),
                    _buildDrawerSubItem(
                      "Hostel Attendence",
                      () => Get.toNamed('/hostelAttendanceFilter'),
                    ),
                    _buildDrawerSubItem(
                      "Verify Attendence",
                      () => Get.toNamed('/verifyAttendance'),
                    ),
                  ],
                ),
                _buildDrawerItem(
                  Icons.assignment_outlined,
                  "Exams List",
                  hasDropdown: true,
                  children: [
                    _buildDrawerSubItem(
                      "Exams List",
                      () => Get.toNamed('/examsList'),
                    ),
                  ],
                ),
                _buildDrawerItem(
                  Icons.groups_outlined,
                  "Hr Management",
                  hasDropdown: true,
                  children: [
                    _buildDrawerSubItem(
                      "Staff List",
                      () => Get.toNamed('/staff'),
                    ),
                    _buildDrawerSubItem(
                      "Staff Attendance",
                      () => Get.toNamed('/staffAttendance'),
                    ),
                  ],
                ),
                _buildDrawerItem(
                  Icons.directions_walk_rounded,
                  "Outing",
                  hasDropdown: true,
                  children: [
                    _buildDrawerSubItem(
                      "Outing list",
                      () => Get.toNamed('/outingList'),
                    ),
                    _buildDrawerSubItem(
                      "Verify Outing",
                      () => Get.toNamed('/outingPending'),
                    ),
                  ],
                ),
                _buildDrawerItem(Icons.logout_rounded, "Leaves"),
                _buildDrawerItem(
                  Icons.school_outlined,
                  "Student View",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentSearchPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.menu_book_outlined,
                  "Syllabus",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSyllabusPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(Icons.table_chart_outlined, "Time Table"),
                _buildDrawerItem(
                  Icons.edit_note_outlined,
                  "Homework",
                  onTap: () => Get.toNamed('/assignments'),
                ),
                _buildDrawerItem(
                  Icons.chat_bubble_outline_rounded,
                  "Chat",
                  onTap: () => Get.toNamed('/chat'),
                ),
                _buildDrawerItem(
                  Icons.campaign_outlined,
                  "Communication",
                  onTap: () => Get.toNamed('/communication'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title, {
    bool hasDropdown = false,
    VoidCallback? onTap,
    List<Widget>? children,
  }) {
    if (children != null && children.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 2,
            ),
            iconColor: const Color(0xFF757575),
            collapsedIconColor: const Color(0xFF757575),
            leading: Icon(icon, color: const Color(0xFF424242), size: 22),
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.only(
              left: 45,
              right: 18,
              bottom: 12,
            ),
            children: children,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF424242), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (hasDropdown)
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF757575),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSubItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF6B7AF5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF616161),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF7E57C2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", true),
          _buildNavItem(Icons.bar_chart, "Attendance", false),
          _buildNavItem(Icons.account_balance_wallet_outlined, "Fees", false),
          _buildNavItem(Icons.person_outline, "Profile", false),
        ],
      ),
    );
  }

  Widget _buildFinanceBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => controller.fetchFinanceData(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      final info = controller.financeData.value.infodata;
      if (info == null) {
        return const Center(
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinanceStatsGrid(),
          const SizedBox(height: 25),
          _buildFinanceChartCard(
            "Total Income Branch Wise",
            _buildTotalIncomeBranchWiseChart(),
          ),
          const SizedBox(height: 20),
          _buildFinanceChartCard(
            "Total Fee Due/Paid",
            _buildFeeDuePaidDonutChart(),
          ),
          const SizedBox(height: 20),
          _buildFeeCollectionInfoSection(),
          const SizedBox(height: 20),
          _buildFinanceChartCard(
            "Total Fee Due/Paid Branch Wise",
            _buildDuePaidBranchProgressBarList(),
          ),
          const SizedBox(height: 20),
          _buildFinanceChartCard(
            "Expense vs Income - April 24",
            _buildExpenseVsIncomeLineChart(),
          ),
          const SizedBox(height: 20),
          _buildExpensesInfoSection(),
          const SizedBox(height: 20),
          _buildCashHoldingSection(),
        ],
      );
    });
  }

  Widget _buildFinanceStatsGrid() {
    final info = controller.financeData.value.infodata;
    return Column(
      children: [
        _buildStatCard(
          "Today Income",
          "${info?.todayIncomeInfo ?? 0}",
          IconifyIcons.todayIncome,
          [const Color(0xFF6B7AF5), const Color(0xFF5C6BC0)],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          "Today Expense",
          "${info?.todayExpenseInfo ?? 0}",
          IconifyIcons.todayExpense,
          [const Color(0xFFFFB755), const Color(0xFFFB8C00)],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          "Month Income",
          "${info?.monthIncomeInfo ?? 0}",
          IconifyIcons.doubleArrowDown,
          [const Color(0xFF4EE298), const Color(0xFF43A047)],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          "Month Expense",
          "${info?.monthExpenseInfo ?? 0}",
          IconifyIcons.doubleArrowUp,
          [const Color(0xFF46B1FF), const Color(0xFF1E88E5)],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          "Total Income",
          "${info?.totalIncomeInfo ?? 0}",
          IconifyIcons.totalIncome,
          [const Color(0xFFF1597E), const Color(0xFFD81B60)],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          "Total Expense",
          "${info?.totalExpenseInfo ?? 0}",
          IconifyIcons.totalExpense,
          [const Color(0xFF26A69A), const Color(0xFF00897B)],
        ),
      ],
    );
  }

  Widget _buildFinanceChartCard(
    String title,
    Widget chart, {
    bool showTabs = false,
    List<String>? tabLabels,
    String? activeTab,
    void Function(String)? onTabChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (showTabs && tabLabels != null && onTabChanged != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabLabels
                    .map(
                      (label) => _buildSmallTab(
                        label,
                        activeTab == label,
                        () => onTabChanged(label),
                      ),
                    )
                    .toList(),
              ),
            ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTab(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? const Color(0xFF8B5CF6) : Colors.black54,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: const Color(0xFF8B5CF6),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalIncomeBranchWiseChart() {
    final info = controller.financeData.value.infodata;
    final collectionList = info?.thisMonthFeeCollectionInfo ?? [];
    double grandTotal = 0;
    for (var item in collectionList) {
      grandTotal += double.tryParse(item.total?.toString() ?? '0') ?? 0;
    }

    final List<Color> colors = [
      const Color(0xFFFF6B6B), // Coral Red
      const Color(0xFFFFBD69), // Pastel Orange
      const Color(0xFF7E57C2), // Medium Purple
      const Color(0xFF03A9F4), // Azure
      const Color(0xFF00D084), // Spring Green
      const Color(0xFFFFB900), // Amber
      const Color(0xFFFF2D55), // Strong Red
      const Color(0xFF8BC34A), // Light Moss Green
      const Color(0xFF7ED321), // Bright Lime
      const Color(0xFF009688), // Dark Teal
    ];

    if (collectionList.isEmpty) {
      return const Center(child: Text("No branch income data"));
    }

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: collectionList.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[entry.key % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value.branchName ?? "",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 141,
              height: 141,
              child: PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  sections: collectionList.asMap().entries.map((entry) {
                    final total =
                        double.tryParse(entry.value.total?.toString() ?? '0') ??
                        0;
                    return PieChartSectionData(
                      value: total,
                      color: colors[entry.key % colors.length],
                      radius: 70.5,
                      showTitle: true,
                      title: grandTotal > 0
                          ? '${(total / grandTotal * 100).toStringAsFixed(1)}%'
                          : '0%',
                      titleStyle: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeDuePaidDonutChart() {
    final info = controller.financeData.value.infodata;
    final branchFeeList = info?.branchwiseTotalFee ?? [];

    double totalPaid = 0;
    double totalDue = 0;

    for (var item in branchFeeList) {
      totalPaid += double.tryParse(item.totalPaid?.toString() ?? '0') ?? 0;
      totalDue += double.tryParse(item.totalDue?.toString() ?? '0') ?? 0;
    }

    double total = totalPaid + totalDue;
    double paidPercentage = total > 0 ? (totalPaid / total * 100) : 0;
    double duePercentage = total > 0 ? (totalDue / total * 100) : 0;

    return Column(
      children: [
        SizedBox(
          width: 234,
          height: 156,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 180,
              sections: [
                PieChartSectionData(
                  value: totalPaid,
                  color: const Color(0xFF26A69A),
                  title: '${paidPercentage.toStringAsFixed(1)}%',
                  radius: 30,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.3,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: totalDue,
                  color: const Color(0xFF5C6BC0),
                  title: '${duePercentage.toStringAsFixed(1)}%',
                  radius: 30,
                  showTitle: true,
                  titlePositionPercentageOffset: 1.3,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
              centerSpaceRadius: 45,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem("Paid", const Color(0xFF26A69A)),
            const SizedBox(width: 20),
            _buildLegendItem("Due", const Color(0xFF5C6BC0)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeCollectionInfoSection() {
    final info = controller.financeData.value.infodata;

    // Pick data list based on active fee tab
    final collectionList = _activeFeeTab == "Todays"
        ? (info?.todaysFeeCollectionInfo ?? [])
        : _activeFeeTab == "Yesterdays"
        ? (info?.yesterdaysFeeCollectionInfo ?? [])
        : _activeFeeTab == "Month"
        ? (info?.thisMonthFeeCollectionInfo ?? [])
        : (info?.feeCollectionInfo ?? []);

    // Calculate totals for summary
    double totalCash = 0;
    double totalUPI = 0;
    double totalCheque = 0;
    double grandTotal = 0;

    for (var item in collectionList) {
      totalCash += double.tryParse(item.cash?.toString() ?? '0') ?? 0;
      totalUPI += double.tryParse(item.upi?.toString() ?? '0') ?? 0;
      totalCheque += double.tryParse(item.cheque?.toString() ?? '0') ?? 0;
      grandTotal += double.tryParse(item.total?.toString() ?? '0') ?? 0;
    }

    return _buildFinanceChartCard(
      "Fee collection Info",
      Column(
        children: [
          if (collectionList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            ...collectionList.asMap().entries.map((entry) {
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildInfoListCard(
                  entry.key + 1,
                  item.branchName ?? "",
                  item.cash?.toString() ?? "0",
                  item.upi?.toString() ?? "0",
                  item.cheque?.toString() ?? "0",
                  item.total?.toString() ?? "0",
                ),
              );
            }),
          _buildFinanceSummaryCard(
            grandTotal.toStringAsFixed(0),
            totalCash.toStringAsFixed(0),
            totalUPI.toStringAsFixed(0),
            totalCheque.toStringAsFixed(0),
          ),
        ],
      ),
      showTabs: true,
      tabLabels: const ["Todays", "Yesterdays", "Month", "Total"],
      activeTab: _activeFeeTab,
      onTabChanged: (tab) {
        setState(() => _activeFeeTab = tab);
      },
    );
  }

  Widget _buildInfoListCard(
    int sNo,
    String branch,
    String cash,
    String upi,
    String cheque,
    String total,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Branch : ",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                branch,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          _buildInfoRow("CASH", cash),
          _buildInfoRow("UPI", upi),
          _buildInfoRow("CHEQUE", cheque),
          const Divider(),
          _buildInfoRow("Total", total),
        ],
      ),
    );
  }

  Widget _buildFinanceSummaryCard(
    String total,
    String cash,
    String upi,
    String cheque,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF9575CD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total : $total",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem("CASH", cash),
              _buildSummaryItem("UPI", upi),
              _buildSummaryItem("CHEQUE", cheque),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDuePaidBranchProgressBarList() {
    final info = controller.financeData.value.infodata;
    final branchFeeList = info?.branchwiseTotalFee ?? [];
    return Column(
      children: branchFeeList
          .map((item) => _buildBranchProgressRow(item))
          .toList(),
    );
  }

  Widget _buildBranchProgressRow(BranchwiseTotalFee item) {
    double paid = double.tryParse(item.totalPaid?.toString() ?? '0') ?? 0;
    double total = double.tryParse(item.total?.toString() ?? '0') ?? 0;
    double progress = (total > 0) ? (paid / total) : 0;
    int percentage = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.branchName ?? "",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$percentage%",
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF3EDFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF26A69A),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseVsIncomeLineChart() {
    final info = controller.financeData.value.infodata;
    final chartData = info?.incomeExpenseInfo ?? [];

    if (chartData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No monthly chart data")),
      );
    }

    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double maxX = (chartData.length - 1).toDouble();
    double maxY = 0;

    for (int i = 0; i < chartData.length; i++) {
      double inc = double.tryParse(chartData[i].income?.toString() ?? '0') ?? 0;
      double exp =
          double.tryParse(chartData[i].expense?.toString() ?? '0') ?? 0;
      incomeSpots.add(FlSpot(i.toDouble(), inc));
      expenseSpots.add(FlSpot(i.toDouble(), exp));
      if (inc > maxY) maxY = inc;
      if (exp > maxY) maxY = exp;
    }

    // Add some buffer to maxY
    maxY = maxY * 1.1;
    if (maxY == 0) maxY = 1000000;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < chartData.length) {
                        String month = chartData[index].month ?? "";
                        // Extract only the month part if it's like "2025 Apr"
                        if (month.contains(" ")) {
                          month = month.split(" ").last;
                        }
                        return Text(month, style: const TextStyle(fontSize: 8));
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text("");
                      if (value >= 1000000) {
                        return Text(
                          '${(value / 1000000).toInt()}M',
                          style: const TextStyle(fontSize: 8),
                        );
                      } else if (value >= 1000) {
                        return Text(
                          '${(value / 1000).toInt()}K',
                          style: const TextStyle(fontSize: 8),
                        );
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 8),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: incomeSpots,
                  isCurved: true,
                  color: const Color(0xFF46B1FF), // Blue for Income
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF46B1FF).withAlpha(30),
                  ),
                ),
                LineChartBarData(
                  spots: expenseSpots,
                  isCurved: true,
                  color: const Color(0xFF4EE298), // Green for Expenses
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF4EE298).withAlpha(30),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem("Expenses", const Color(0xFF4EE298)),
            const SizedBox(width: 20),
            _buildLegendItem("Income", const Color(0xFF46B1FF)),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesInfoSection() {
    final info = controller.financeData.value.infodata;

    // Pick data list based on active expense tab
    dynamic expenseList;
    String totalAmount = "0";

    if (_activeExpenseTab == "Todays") {
      expenseList = info?.expensesInfoToday ?? [];
      totalAmount = "${info?.todayExpenseInfo ?? 0}";
    } else if (_activeExpenseTab == "Yesterdays") {
      expenseList = info?.yesterdayExpenseTableData ?? [];
      // Calculate total from table data if summary not directly available
      double sum = 0;
      for (var item in (expenseList as List<ExpenseTableData>)) {
        sum += double.tryParse(item.total?.toString() ?? '0') ?? 0;
      }
      totalAmount = sum.toStringAsFixed(0);
    } else if (_activeExpenseTab == "Month") {
      expenseList = info?.expensesInfoThisMonth ?? [];
      totalAmount = "${info?.monthExpenseInfo ?? 0}";
    } else {
      // Total
      expenseList = info?.totalExpenseTableData ?? [];
      totalAmount = "${info?.totalExpenseInfo ?? 0}";
    }

    return _buildFinanceChartCard(
      "Expenses Info",
      Column(
        children: [
          if (expenseList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else ...[
            ...expenseList.asMap().entries.map((entry) {
              final item = entry.value;
              if (item is ExpenseItem) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildExpenseItemCard(
                    entry.key + 1,
                    item.branchName ?? "",
                    item.ledgername ?? "",
                    item.amount?.toString() ?? "0",
                  ),
                );
              } else if (item is ExpenseTableData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildExpenseTableDataCard(
                    entry.key + 1,
                    item.branchName ?? "",
                    item.cash?.toString() ?? "0",
                    item.upi?.toString() ?? "0",
                    item.cheque?.toString() ?? "0",
                    item.total?.toString() ?? "0",
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
          _buildSimpleTotalBar(totalAmount),
        ],
      ),
      showTabs: true,
      tabLabels: const ["Todays", "Yesterdays", "Month", "Total"],
      activeTab: _activeExpenseTab,
      onTabChanged: (tab) {
        setState(() => _activeExpenseTab = tab);
      },
    );
  }

  Widget _buildExpenseTableDataCard(
    int sNo,
    String branch,
    String cash,
    String upi,
    String cheque,
    String total,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Branch : ",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                branch,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Divider(),
          _buildInfoRow("CASH", cash),
          _buildInfoRow("UPI", upi),
          _buildInfoRow("CHEQUE", cheque),
          const Divider(),
          _buildInfoRow("Total", total),
        ],
      ),
    );
  }

  Widget _buildCashHoldingSection() {
    final info = controller.financeData.value.infodata;
    final cashList = info?.cashholdings ?? [];

    return _buildFinanceChartCard(
      "Cash Holding",
      Column(
        children: [
          ...cashList.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCashHolderCard(
                entry.key + 1,
                item.username ?? "",
                item.netBalance?.toString() ?? "0",
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCashHolderCard(int sNo, String name, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Cash Holder : ",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Amount : ",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItemCard(
    int sNo,
    String branch,
    String head,
    String amount,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S.NO: $sNo",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Divider(),
          _buildInfoRow("Branch", branch),
          _buildInfoRow("Expense Head", head),
          _buildInfoRow("Amount", amount),
        ],
      ),
    );
  }

  Widget _buildSimpleTotalBar(String total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF9575CD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Total : $total",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(64),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        else
          Icon(icon, color: Colors.white.withAlpha(178), size: 24),
      ],
    );
  }
}
