import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/profile_controller.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:student_app/staff_app/utils/iconify_icons.dart';
import 'package:student_app/admin_app/admin_bottom_nav_bar.dart';

class AdminStaffDashboardPage extends StatefulWidget {
  const AdminStaffDashboardPage({super.key});

  @override
  State<AdminStaffDashboardPage> createState() =>
      _AdminStaffDashboardPageState();
}

class _AdminStaffDashboardPageState extends State<AdminStaffDashboardPage> {
  late ProfileController profileCtrl;
  String selectedYear = "2025-2026";
  @override
  void initState() {
    super.initState();
    profileCtrl = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);
    Get.put(AdminMainController(), permanent: true).changeIndex(0);
  }

  final List<String> years = [
    "2023-2024",
    "2024-2025",
    "2025-2026",
    "2026-2027",
  ];

  final List<Map<String, dynamic>> colleges = const [
    {"name": "Pelluru", "present": 75, "absent": 25},
    {"name": "VRB", "present": 65, "absent": 35},
    {"name": "PVB", "present": 75, "absent": 25},
    {"name": "Vidya Bhavan", "present": 75, "absent": 25},
    {"name": "Padmavathi", "present": 65, "absent": 35},
    {"name": "MM Road", "present": 75, "absent": 25},
    {"name": "AVP", "present": 65, "absent": 35},
    {"name": "Tallur", "present": 75, "absent": 25},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminHeader(title: "Staff Dashboard"),
          Expanded(child: _buildDashboardBody()),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }

  // Dashboard Body

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                onSelected: (v) => setState(() => selectedYear = v),
                itemBuilder: (context) => years
                    .map((y) => PopupMenuItem(value: y, child: Text(y)))
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedYear,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black54,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.9, // Slightly taller to prevent overflow
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: [
              _buildStatCard(
                "Total Students",
                "6902",
                IconifyIcons.humbleIconsUsers,
                [const Color(0xFF28CDC0), const Color(0xFF2EC0CD)],
              ),
              _buildStatCard(
                "Day Scholars",
                "2,047",
                IconifyIcons.hugeIconsBus03,
                [const Color(0xFFF26FA3), const Color(0xFFCB365B)],
              ),
              _buildStatCard(
                "Hostel",
                "4,854",
                IconifyIcons.clarityBuildingLine,
                [const Color(0xFFF6AE39), const Color(0xFFF58F36)],
              ),
              _buildStatCard(
                "Today's Outing",
                "14",
                IconifyIcons.tablerUserMinus,
                [const Color(0xFF29A7ED), const Color(0xFF2986E9)],
              ),
              _buildStatCard(
                "Today Present",
                "4,130",
                IconifyIcons.tablerUserCheck,
                [const Color(0xFF24BF7A), const Color(0xFF2BB78B)],
              ),
              _buildStatCard("Today Absent", "772", IconifyIcons.tablerUserX, [
                const Color(0xFFE23555),
                const Color(0xFFDD357B),
              ]),
            ],
          ),

          const SizedBox(height: 30),
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 173 / 105,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildQuickAction(
                "Class Attendance",
                IconifyIcons.tablerUserCheck,
                const Color(0xFF43A089), // Exact teal from mockup
                () => Get.toNamed('/classAttendance'),
              ),
              _buildQuickAction(
                "Hostel Attendance",
                IconifyIcons.tablerCalendarCheck,
                const Color(0xFFF39C12), // Exact orange from mockup
                () => Get.toNamed('/hostelAttendanceFilter'),
              ),
              _buildQuickAction(
                "Issue Outing",
                IconifyIcons.tablerBackpack,
                const Color(0xFF26C6DA), // Exact cyan from mockup
                () => Get.toNamed('/outingList'),
              ),
              _buildQuickAction(
                "Verify Outing",
                IconifyIcons.tablerShieldCheck,
                const Color(0xFFF06292), // Exact pink from mockup
                () => Get.toNamed('/outingPending'),
              ),
            ],
          ),

          const SizedBox(height: 25),
          const Text(
            "Students Attendance",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: colleges
                  .map(
                    (c) => _buildAttendanceBar(
                      c["name"],
                      c["present"],
                      c["present"] >= 70
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String iconData,
    List<Color> colors,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12), // Exact 12px radius
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Bubble
          Positioned(
            top: -15,
            left: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12), // Exact 12px padding
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
                          fontSize: 14, // Adjusted for consistency
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22, // Reduced from 24 to prevent overflow
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Icon Container
                Container(
                  width: 44, // Exact 44px width
                  height: 44, // Exact 44px height
                  padding: const EdgeInsets.all(6), // Exact 6px padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Matching icon radius
                  ),
                  child: Iconify(
                    iconData,
                    color: Colors.white,
                    size: 32, // Consistent with quick actions
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    String iconData,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25)),
            BoxShadow(color: Colors.white, spreadRadius: 0.0, blurRadius: 8.0),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Iconify(iconData, color: iconColor, size: 38),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceBar(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$percentage%",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white,
              color: color,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
