import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../widgets/skeleton.dart';

import '../widgets/staff_header.dart';
import '../model/room_attendance_model.dart';

class HostelAttendanceResultPage extends StatefulWidget {
  const HostelAttendanceResultPage({super.key});

  @override
  State<HostelAttendanceResultPage> createState() =>
      _HostelAttendanceResultPageState();
}

class _HostelAttendanceResultPageState
    extends State<HostelAttendanceResultPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  late final HostelController hostelCtrl;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<HostelController>()) {
      Get.put(HostelController(), permanent: true);
    }
    hostelCtrl = Get.find<HostelController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSummary();
    });
  }

  Future<void> _loadSummary() async {
    final Map<String, dynamic> args =
        Get.arguments as Map<String, dynamic>? ?? {};

    final String branch =
        args['branch']?.toString() ?? hostelCtrl.activeBranch.value.toString();
    final String date = args['date'] ?? hostelCtrl.activeDate.value;
    final String hostel =
        args['hostel']?.toString() ?? hostelCtrl.activeHostel.value.toString();
    final String floor = args['floor']?.toString() ?? 'All';
    final String room = args['room']?.toString() ?? 'All';

    hostelCtrl.activeBranch.value = branch;
    hostelCtrl.activeDate.value = date;
    hostelCtrl.activeHostel.value = hostel;
    hostelCtrl.activeFloor.value = floor;
    hostelCtrl.activeFloorName.value = args['floorName']?.toString() ?? floor;
    hostelCtrl.activeRoomName.value = args['roomName']?.toString() ?? room;

    if (room != 'All') {
      // If a specific room is selected, load student details
      await hostelCtrl.loadRoomAttendanceDetails(room);
      // Also clear summary to avoid confusion
      hostelCtrl.roomsSummary.clear();
    } else {
      // Otherwise load room summary for the floor/hostel
      hostelCtrl.roomAttendanceDetails.clear();
      await hostelCtrl.loadRoomAttendanceSummary(
        branch: branch,
        date: date,
        hostel: hostel,
        floor: floor,
        room: room,
      );
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: 'Hostel Attendance'),

          // ── BODY LAVENDER CONTAINER ──────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF), // Soft Lavender
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  // ── SEARCH BAR ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF7C3AED),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (val) {
                          setState(() {
                            _query = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search floor / hostel',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ── LIST ───────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      if (hostelCtrl.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: SkeletonList(itemCount: 5),
                        );
                      }
                      // Use roomAttendanceDetails if available (student-wise), otherwise roomsSummary
                      final bool isStudentView =
                          hostelCtrl.roomAttendanceDetails.isNotEmpty;

                      final List data = isStudentView
                          ? hostelCtrl.roomAttendanceDetails
                          : (hostelCtrl.roomsSummary.isNotEmpty
                                ? List.from(hostelCtrl.roomsSummary)
                                : [
                                    {
                                      'room': 'C-201',
                                      'floor': '2nd floor C & D blocks',
                                      'incharge': 'Gosu Abhishek Sagar',
                                      'total': '8',
                                      'present': '0',
                                      'absent': '8',
                                    },
                                    {
                                      'room': 'C-201',
                                      'floor': '2nd floor C & D blocks',
                                      'incharge': 'Gosu Abhishek Sagar',
                                      'total': '8',
                                      'present': '0',
                                      'absent': '8',
                                    },
                                  ]);

                      final q = _query.toLowerCase();
                      final filtered = data.where((item) {
                        String room = '';
                        String floor = '';
                        String searchField = ''; // incharge or student name

                        if (item is RoomAttendanceModel) {
                          room = hostelCtrl.activeRoomName.value.toLowerCase();
                          floor = hostelCtrl.activeFloorName.value
                              .toLowerCase();
                          searchField = item.studentName.toLowerCase();
                        } else if (item is Map) {
                          room = item['room']?.toString().toLowerCase() ?? '';
                          floor = item['floor']?.toString().toLowerCase() ?? '';
                          searchField =
                              item['incharge']?.toString().toLowerCase() ?? '';
                        }

                        return q.isEmpty ||
                            room.contains(q) ||
                            floor.contains(q) ||
                            searchField.contains(q);
                      }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _AttendanceCard(
                          data: filtered[index],
                          sno: index + 1,
                        ),
                      );
                    }),
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

class _AttendanceCard extends StatefulWidget {
  final dynamic data;
  final int sno;

  const _AttendanceCard({required this.data, required this.sno, super.key});

  @override
  State<_AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<_AttendanceCard> {
  late String morningStatus;
  late String nightStatus;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  void _initializeStatus() {
    if (widget.data is RoomAttendanceModel) {
      final model = widget.data as RoomAttendanceModel;
      final hostelCtrl = Get.find<HostelController>();
      final dateStr = hostelCtrl.activeDate.value;

      String dayKey = "";
      if (dateStr.isNotEmpty) {
        try {
          if (dateStr.contains('-')) {
            final parts = dateStr.split('-');
            // handle yyyy-mm-dd or dd-mm-yyyy
            dayKey = parts.last.length == 4 ? parts.first : parts.last;
            // remove leading zero
            dayKey = int.parse(dayKey).toString();
          }
        } catch (e) {
          debugPrint("Date Parsing Error: $e");
        }
      }

      final attMap = model.attendanceMap;
      if (attMap != null && dayKey.isNotEmpty && attMap.containsKey(dayKey)) {
        final dayData = attMap[dayKey];
        // User rule: if 'P' then 'P', else 'A'
        final m = dayData['Morning']?.toString() ?? '';
        final n = dayData['Night']?.toString() ?? '';

        morningStatus = (m == 'P') ? 'P' : 'A';
        nightStatus = (n == 'P') ? 'P' : 'A';
      } else {
        morningStatus = 'A';
        nightStatus = 'A';
      }
    } else {
      morningStatus = 'P';
      nightStatus = 'P';
    }
  }

  @override
  void didUpdateWidget(_AttendanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _initializeStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hostelCtrl = Get.find<HostelController>();
    String roomName = '-';
    String floorName = '-';
    String label = 'Incharge:';
    String nameValue = 'N/A';

    if (widget.data is RoomAttendanceModel) {
      final model = widget.data as RoomAttendanceModel;
      roomName = hostelCtrl.activeRoomName.value.isNotEmpty
          ? hostelCtrl.activeRoomName.value
          : model.admno;
      floorName = hostelCtrl.activeFloorName.value;
      label = 'Student Name:';
      nameValue = model.studentName;
    } else if (widget.data is Map) {
      roomName = widget.data['room']?.toString() ?? '-';
      floorName = widget.data['floor']?.toString() ?? '-';
      label = 'Incharge:';
      nameValue = widget.data['incharge']?.toString() ?? 'N/A';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── HEADER: Room Name ──────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED), // Theme Purple
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              roomName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // ── BODY ──────────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                // LEFT COLUMN: Floor and Incharge
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelValue('floor:', floorName),
                        const SizedBox(height: 8),
                        _buildLabelValue(label, nameValue),
                      ],
                    ),
                  ),
                ),

                // VERTICAL DIVIDER
                Container(width: 1, color: Colors.grey.withOpacity(0.15)),

                // RIGHT COLUMN: Morning and Night Status
                Container(
                  width: 105,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'morning',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusBox(
                        text: morningStatus,
                        color: morningStatus == 'P'
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        onTap: () {
                          setState(() {
                            morningStatus = morningStatus == 'P' ? 'A' : 'P';
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'night',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusBox(
                        text: nightStatus,
                        color: nightStatus == 'P'
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        onTap: () {
                          setState(() {
                            nightStatus = nightStatus == 'P' ? 'A' : 'P';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _StatusBox extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _StatusBox({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
