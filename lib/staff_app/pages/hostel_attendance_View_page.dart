import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';
import '../controllers/hostel_controller.dart';
import '../model/branch_model.dart';
import '../model/hostel_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';
import '../widgets/staff_header.dart';

class HostelAttendanceFilterPage extends StatefulWidget {
  const HostelAttendanceFilterPage({super.key});

  @override
  State<HostelAttendanceFilterPage> createState() =>
      _HostelAttendanceFilterPageState();
}

class _HostelAttendanceFilterPageState
    extends State<HostelAttendanceFilterPage> {
  // Selected model objects (for IDs)
  BranchModel? _selectedBranch;
  HostelModel? _selectedHostel;
  FloorModel? _selectedFloor;
  RoomModel? _selectedRoom;
  DateTime _selectedDate = DateTime.now();

  final BranchController branchCtrl = Get.put(BranchController());
  final HostelController hostelCtrl = Get.find<HostelController>();

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    // Load branches on open
    branchCtrl.loadBranches();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ─── Cascade helpers ───────────────────────────────────────────────────────

  void _onBranchChanged(BranchModel? branch) {
    setState(() {
      _selectedBranch = branch;
      _selectedHostel = null;
      _selectedFloor = null;
      _selectedRoom = null;
    });
    hostelCtrl.hostels.clear();
    hostelCtrl.floorModels.clear();
    hostelCtrl.roomModels.clear();
    if (branch != null) hostelCtrl.loadHostelsByBranch(branch.id);
  }

  void _onHostelChanged(HostelModel? hostel) {
    setState(() {
      _selectedHostel = hostel;
      _selectedFloor = null;
      _selectedRoom = null;
    });
    hostelCtrl.floorModels.clear();
    hostelCtrl.roomModels.clear();
    if (hostel != null) hostelCtrl.loadFloorsByHostel(hostel.id);
  }

  void _onFloorChanged(FloorModel? floor) {
    setState(() {
      _selectedFloor = floor;
      _selectedRoom = null;
    });
    hostelCtrl.roomModels.clear();
    if (floor != null) hostelCtrl.loadRoomsByFloor(floor.id);
  }

  void _onRoomChanged(RoomModel? room) {
    setState(() => _selectedRoom = room);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: "Hostel Attendance"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: _buildFilterContainer(context),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  // ─── Filter container ───────────────────────────────────────────────────────

  Widget _buildFilterContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Branch ──────────────────────────────────────────────────────────
          Obx(() {
            final items = branchCtrl.branches.toList();
            return _buildDropdown<BranchModel>(
              label: "Branch",
              hint: "Select Branch",
              // branchCtrl.isLoading.value ? "Loading..." : "Select Branch",
              selectedItem: _selectedBranch,
              items: items,
              displayText: (b) => b.branchName,
              onChanged: _onBranchChanged,
            );
          }),
          const SizedBox(height: 15),

          // ── Hostel ──────────────────────────────────────────────────────────
          Obx(() {
            final items = hostelCtrl.hostels.toList();
            final isLoading = hostelCtrl.isLoading.value;
            final isEnabled = _selectedBranch != null;
            return _buildDropdown<HostelModel>(
              label: "Hostel",
              hint: !isEnabled
                  ? "Select Branch first"
                  : isLoading
                  ? "Loading..."
                  : items.isEmpty
                  ? "No hostels found"
                  : "Select Hostel",
              selectedItem: _selectedHostel,
              items: items,
              displayText: (h) => h.buildingName,
              onChanged: isEnabled && !isLoading && items.isNotEmpty
                  ? _onHostelChanged
                  : null,
            );
          }),
          const SizedBox(height: 15),

          // ── Floor ───────────────────────────────────────────────────────────
          Obx(() {
            final items = hostelCtrl.floorModels.toList();
            final isLoading = hostelCtrl.isLoading.value;
            final isEnabled = _selectedHostel != null;
            return _buildDropdown<FloorModel>(
              label: "Floor",
              hint: !isEnabled
                  ? "Select Hostel first"
                  : isLoading
                  ? "Loading..."
                  : items.isEmpty
                  ? "No floors found"
                  : "Select Floor",
              selectedItem: _selectedFloor,
              items: items,
              displayText: (f) => f.floorName,
              onChanged: isEnabled && !isLoading && items.isNotEmpty
                  ? _onFloorChanged
                  : null,
            );
          }),
          const SizedBox(height: 15),

          // ── Room ────────────────────────────────────────────────────────────
          Obx(() {
            final items = hostelCtrl.roomModels.toList();
            final isLoading = hostelCtrl.isLoading.value;
            final isEnabled = _selectedFloor != null;
            return _buildDropdown<RoomModel>(
              label: "Room",
              hint: !isEnabled
                  ? "Select Floor first"
                  : isLoading
                  ? "Loading..."
                  : items.isEmpty
                  ? "No rooms found"
                  : "Select Room",
              selectedItem: _selectedRoom,
              items: items,
              displayText: (r) => r.roomName,
              onChanged: isEnabled && !isLoading && items.isNotEmpty
                  ? _onRoomChanged
                  : null,
            );
          }),
          const SizedBox(height: 15),

          // Date Selection
          _buildDateField(context),
          const SizedBox(height: 25),
          _buildGetStudentsButton(),
        ],
      ),
    );
  }

  // ─── Generic typed dropdown ─────────────────────────────────────────────────

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required T? selectedItem,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: onChanged == null ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selectedItem,
              hint: Text(
                hint,
                style: TextStyle(
                  color: onChanged == null
                      ? Colors.grey.shade400
                      : const Color(0xFF6B7280),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 28,
              ),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText(item),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Date Field ─────────────────────────────────────────────────────────────

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Date",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 15,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Get Students button ────────────────────────────────────────────────────

  Widget _buildGetStudentsButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            if (_selectedBranch != null &&
                _selectedHostel != null &&
                _selectedFloor != null &&
                _selectedRoom != null) {
              final String dateStr = _selectedDate.toIso8601String().split(
                'T',
              )[0];

              Get.toNamed(
                '/hostelAttendanceResult',
                arguments: {
                  // New keys for Result Page
                  'branch': _selectedBranch!.id.toString(),
                  'hostel': _selectedHostel!.id.toString(),
                  'floor': _selectedFloor!.id.toString(),
                  'room': _selectedRoom!.id.toString(),
                  'date': dateStr,
                  // Existing keys (kept for safety if needed by other components)
                  'branchId': _selectedBranch!.id.toString(),
                  'branchName': _selectedBranch!.branchName,
                  'hostelId': _selectedHostel!.id.toString(),
                  'hostelName': _selectedHostel!.buildingName,
                  'floorId': _selectedFloor!.id.toString(),
                  'floorName': _selectedFloor!.floorName,
                  'roomId': _selectedRoom!.id.toString(),
                  'roomName': _selectedRoom!.roomName,
                  'month': months[_selectedDate.month - 1],
                },
              );
            } else {
              Get.snackbar(
                "Info",
                "Please select all fields",
                backgroundColor: Colors.white,
              );
            }
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get Students",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bottom buttons ─────────────────────────────────────────────────────────

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          // Add Attendance
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (_selectedBranch != null &&
                        _selectedHostel != null &&
                        _selectedFloor != null &&
                        _selectedRoom != null) {
                      Get.toNamed(
                        '/addHostelAttendance',
                        arguments: {
                          'branchId': _selectedBranch!.id.toString(),
                          'branchName': _selectedBranch!.branchName,
                          'hostelId': _selectedHostel!.id.toString(),
                          'hostelName': _selectedHostel!.buildingName,
                          'floorId': _selectedFloor!.id.toString(),
                          'floorName': _selectedFloor!.floorName,
                          'roomId': _selectedRoom!.id.toString(),
                          'roomName': _selectedRoom!.roomName,
                          'month': months[_selectedDate.month - 1],
                          'date': _selectedDate.toIso8601String().split('T')[0],
                        },
                      );
                    } else {
                      Get.snackbar(
                        'Info',
                        'Please select Branch, Hostel, Floor and Room first',
                        backgroundColor: Colors.white,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 22),
                        SizedBox(width: 4),
                        Text(
                          "Add Attendance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Check Status
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3FAFB9), Color(0xFFAED160)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showStatusPopup(context),
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 22),
                        SizedBox(width: 4),
                        Text(
                          "Check Status",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  void _showStatusPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFFF9FAFB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Check Attendance",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                              letterSpacing: -0.5,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF6B7280),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Branch",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        return _buildPopupDropdown<BranchModel>(
                          hint: "Select Branch",
                          selectedItem: _selectedBranch,
                          items: branchCtrl.branches.toList(),
                          displayText: (b) => b.branchName,
                          onChanged: (val) {
                            setDialogState(() {
                              _onBranchChanged(val);
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16),

                      const Text(
                        "Hostel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        return _buildPopupDropdown<HostelModel>(
                          hint: "Select Hostel",
                          selectedItem: _selectedHostel,
                          items: hostelCtrl.hostels.toList(),
                          displayText: (h) => h.buildingName,
                          onChanged: (val) {
                            setDialogState(() {
                              _onHostelChanged(val);
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16),

                      const Text(
                        "Floor",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        return _buildPopupDropdown<FloorModel>(
                          hint: "Select Floor",
                          selectedItem: _selectedFloor,
                          items: hostelCtrl.floorModels.toList(),
                          displayText: (f) => f.floorName,
                          onChanged: (val) {
                            setDialogState(() {
                              _onFloorChanged(val);
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16),

                      const Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              setState(() => _selectedDate = picked);
                            });
                          }
                        },
                        child: _buildSimpleField(
                          "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedBranch == null ||
                                _selectedHostel == null) {
                              Get.snackbar(
                                "Required Fields",
                                "Please select Branch and Hostel to proceed",
                                backgroundColor: Colors.white.withOpacity(0.9),
                                colorText: Colors.red.shade700,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                                icon: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                              return;
                            }

                            final String date = _selectedDate
                                .toIso8601String()
                                .split('T')[0];

                            await hostelCtrl.loadRoomAttendanceSummary(
                              branch: _selectedBranch!.id.toString(),
                              date: date,
                              hostel: _selectedHostel!.id.toString(),
                              floor: _selectedFloor?.id.toString() ?? "All",
                              room: _selectedRoom?.id.toString() ?? "All",
                            );

                            if (context.mounted) Navigator.pop(context);
                            Get.toNamed('/hostelAttendanceStatus');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Get Attendance",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopupDropdown<T>({
    required String hint,
    required T? selectedItem,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedItem,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF6B7280),
            size: 24,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayText(item),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSimpleField(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Icon(
            Icons.calendar_month_rounded,
            color: Color(0xFF6B7280),
            size: 20,
          ),
        ],
      ),
    );
  }
}
