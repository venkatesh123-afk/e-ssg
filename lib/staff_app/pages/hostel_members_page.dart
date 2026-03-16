import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';
import '../controllers/hostel_controller.dart';
import 'assign_students_page.dart';
import '../widgets/staff_header.dart';
import '../model/hostel_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';

class HostelMembersPage extends StatefulWidget {
  const HostelMembersPage({super.key});

  @override
  State<HostelMembersPage> createState() => _HostelMembersPageState();
}

class _HostelMembersPageState extends State<HostelMembersPage> {
  // ================= UI Constants =================
  static const Color primaryPurple = Color(0xFF7E49FF);
  static const Color lavenderBg = Color(0xFFF1F4FF);

  final BranchController branchCtrl = Get.put(BranchController());
  final HostelController hostelCtrl = Get.put(HostelController());

  // Filter Values
  final RxString selectedCategory = "Hostel Wise".obs;
  final RxnInt selectedBranchId = RxnInt();
  final RxnInt selectedHostelId = RxnInt();
  final RxnInt selectedFloorId = RxnInt();
  final RxnInt selectedRoomId = RxnInt();
  String _query = "";

  @override
  void initState() {
    super.initState();
    branchCtrl.loadBranches();
  }

  bool _showData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: "Hostel Members"),

          // ================= FILTERS & CONTENT =================
          if (!_showData) ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Column(
                        children: [
                          _buildLabel("Category"),
                          Obx(
                            () => _buildDropdown(
                              hint: "Hostel Wise",
                              value: selectedCategory.value,
                              items: ["Hostel Wise", "Floor Wise", "Room Wise"],
                              onChanged: (val) {
                                if (val != null) {
                                  selectedCategory.value = val;
                                  selectedHostelId.value = null;
                                  selectedFloorId.value = null;
                                  selectedRoomId.value = null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildLabel("Campus"),
                          Obx(
                            () => _buildDropdown(
                              hint: "Select Campus",
                              value: branchCtrl.branches
                                  .firstWhereOrNull(
                                    (b) => b.id == selectedBranchId.value,
                                  )
                                  ?.branchName,
                              items: branchCtrl.branches
                                  .map((b) => b.branchName)
                                  .toList(),
                              onChanged: (val) {
                                final selected = branchCtrl.branches.firstWhere(
                                  (b) => b.branchName == val,
                                );
                                selectedBranchId.value = selected.id;
                                selectedHostelId.value = null;
                                selectedFloorId.value = null;
                                selectedRoomId.value = null;
                                hostelCtrl.loadHostelsByBranch(selected.id);
                              },
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Hostel Dropdown
                          Obx(() {
                            // Access observables early to register dependencies
                            final hostels = hostelCtrl.hostels;
                            final branchId = selectedBranchId.value;
                            final category = selectedCategory.value;
                            final currentHostelId = selectedHostelId.value;

                            if (hostels.isEmpty && branchId != null) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Hostel"),
                                _buildDropdown(
                                  hint: "Select Hostel",
                                  value: hostels
                                      .firstWhereOrNull(
                                        (h) => h.id == currentHostelId,
                                      )
                                      ?.buildingName,
                                  items: hostels
                                      .map((h) => h.buildingName)
                                      .toList(),
                                  onChanged: (val) {
                                    final selected = hostels.firstWhere(
                                      (h) => h.buildingName == val,
                                    );
                                    selectedHostelId.value = selected.id;
                                    selectedFloorId.value = null;
                                    selectedRoomId.value = null;
                                    if (category != "Hostel Wise") {
                                      hostelCtrl.loadFloorsByHostel(
                                        selected.id,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }),

                          // Floor Dropdown
                          Obx(() {
                            final floors = hostelCtrl.floorModels;
                            final category = selectedCategory.value;
                            final floorId = selectedFloorId.value;

                            if (category == "Hostel Wise" || floors.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Floor"),
                                _buildDropdown(
                                  hint: "Select Floor",
                                  value: floors
                                      .firstWhereOrNull((f) => f.id == floorId)
                                      ?.floorName,
                                  items: floors
                                      .map((f) => f.floorName)
                                      .toList(),
                                  onChanged: (val) {
                                    final selected = floors.firstWhere(
                                      (f) => f.floorName == val,
                                    );
                                    selectedFloorId.value = selected.id;
                                    selectedRoomId.value = null;
                                    if (category == "Room Wise") {
                                      hostelCtrl.loadRoomsByFloor(selected.id);
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }),

                          // Room Dropdown
                          Obx(() {
                            final rooms = hostelCtrl.roomModels;
                            final category = selectedCategory.value;
                            final roomId = selectedRoomId.value;

                            if (category != "Room Wise" || rooms.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Room"),
                                _buildDropdown(
                                  hint: "Select Room",
                                  value: rooms
                                      .firstWhereOrNull((r) => r.id == roomId)
                                      ?.roomName,
                                  items: rooms.map((r) => r.roomName).toList(),
                                  onChanged: (val) {
                                    final selected = rooms.firstWhere(
                                      (r) => r.roomName == val,
                                    );
                                    selectedRoomId.value = selected.id;
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }),

                          const SizedBox(height: 20),
                          Obx(
                            () => Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:
                                      (selectedBranchId.value != null &&
                                          (selectedCategory.value ==
                                                  "Hostel Wise"
                                              ? selectedHostelId.value != null
                                              : selectedCategory.value ==
                                                    "Floor Wise"
                                              ? selectedFloorId.value != null
                                              : selectedRoomId.value != null))
                                      ? [
                                          const Color(0xFF856CFB),
                                          const Color(0xFFCD96FB),
                                        ]
                                      : [
                                          const Color(
                                            0xFF856CFB,
                                          ).withOpacity(0.5),
                                          const Color(
                                            0xFFCD96FB,
                                          ).withOpacity(0.5),
                                        ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    (selectedBranchId.value != null &&
                                        (selectedCategory.value == "Hostel Wise"
                                            ? selectedHostelId.value != null
                                            : selectedCategory.value ==
                                                  "Floor Wise"
                                            ? selectedFloorId.value != null
                                            : selectedRoomId.value != null))
                                    ? () async {
                                        String type = "";
                                        String param = "";

                                        if (selectedCategory.value ==
                                            "Hostel Wise") {
                                          type = "hostel";
                                          param = selectedHostelId.value
                                              .toString();
                                        } else if (selectedCategory.value ==
                                            "Floor Wise") {
                                          type = "floor";
                                          param = selectedFloorId.value
                                              .toString();
                                        } else {
                                          type = "room";
                                          param = selectedRoomId.value
                                              .toString();
                                        }

                                        await hostelCtrl.fetchHostelMembers(
                                          type: type,
                                          param: param,
                                        );
                                        setState(() {
                                          _showData = true;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: hostelCtrl.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Get Students",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildEmptyState(),
                  ],
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: lavenderBg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryPurple.withOpacity(0.3),
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
                          onChanged: (v) => setState(() => _query = v),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black54,
                              size: 20,
                            ),
                            hintText: "Search by Name, Adm No, Room....",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          itemCount: hostelCtrl.members
                              .where(
                                (m) =>
                                    m['student_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_query.toLowerCase()) ||
                                    m['admno'].toString().contains(_query),
                              )
                              .length,
                          itemBuilder: (context, i) {
                            final filtered = hostelCtrl.members
                                .where(
                                  (m) =>
                                      m['student_name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(_query.toLowerCase()) ||
                                      m['admno'].toString().contains(_query),
                                )
                                .toList();
                            return _memberCard(filtered[i], i);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ================= ASSIGN STUDENTS BUTTON =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton.icon(
                onPressed: () =>
                    Get.to(() => const AssignStudentsPage(students: [])),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text(
                  "Assign Students",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MEMBER CARD =================
  Widget _memberCard(Map<String, dynamic> data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Room Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['room_name']?.toString() ??
                      data['room']?.toString() ??
                      'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Serial Number Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  "#${index + 1}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data['student_name']?.toString() ?? 'Unknown',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          _infoRow("Adm No", data['admno']?.toString() ?? ''),
          const SizedBox(height: 4),
          _infoRow("Branch", data['branch']?.toString() ?? 'N/A'),
          const SizedBox(height: 14),
          Row(
            children: [
              _squareIcon(
                icon: Icons.edit_outlined,
                bgColor: const Color(0xFFFFF4D2),
                iconColor: const Color(0xFFFFB038),
                onTap: () {
                  _showEditMemberDialog(context, data);
                },
              ),
              const SizedBox(width: 10),
              _squareIcon(
                icon: Icons.delete_outline,
                bgColor: const Color(0xFFFFE6E4),
                iconColor: const Color(0xFFFF6B6B),
                onTap: () {
                  _showDeleteDialog(data);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= EDIT MEMBER DIALOG =================
  void _showEditMemberDialog(BuildContext ctx, Map<String, dynamic> data) {
    final selectedHostel = Rxn<HostelModel>();
    final selectedFloor = Rxn<FloorModel>();
    final selectedRoom = Rxn<RoomModel>();

    // Initial Selections
    if (hostelCtrl.hostels.isNotEmpty) {
      selectedHostel.value = hostelCtrl.hostels.firstWhereOrNull(
        (h) => h.buildingName == (data['hostel'] ?? data['building_name']),
      );
      if (selectedHostel.value != null) {
        hostelCtrl.loadFloorsByHostel(selectedHostel.value!.id).then((_) {
          selectedFloor.value = hostelCtrl.floorModels.firstWhereOrNull(
            (f) => f.floorName == (data['floor'] ?? data['floor_name']),
          );
          if (selectedFloor.value != null) {
            hostelCtrl.loadRoomsByFloor(selectedFloor.value!.id).then((_) {
              selectedRoom.value = hostelCtrl.roomModels.firstWhereOrNull(
                (r) => r.roomName == (data['room'] ?? data['room_name']),
              );
            });
          }
        });
      }
    }

    showDialog(
      context: ctx,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              StaffHeader(
                title: "Edit Hostel Member",
                onBack: () => Navigator.of(dialogContext).pop(),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Student Details Card ----
                      const Text(
                        "Student Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailRow(
                              "Name",
                              data['student_name'] ?? data['name'] ?? "",
                            ),
                            const SizedBox(height: 8),
                            _detailRow(
                              "Adm No",
                              data['admno'] ?? data['admNo'] ?? "",
                            ),
                            const SizedBox(height: 8),
                            _detailRow(
                              "Branch",
                              data['branch'] ?? "SSJC-VIDHYA BHAVAN",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---- Hostel Assignment Card ----
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hostel Assignment",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Change Location chip
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Change Location",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Hostel dropdown
                            const Text(
                              "Hostel",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(
                              () => _editDropdown<HostelModel>(
                                value: selectedHostel.value,
                                items: hostelCtrl.hostels,
                                hint: "Select Hostel",
                                displayFn: (h) => h.buildingName,
                                onChanged: (v) {
                                  selectedHostel.value = v;
                                  selectedFloor.value = null;
                                  selectedRoom.value = null;
                                  if (v != null) {
                                    hostelCtrl.loadFloorsByHostel(v.id);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Floor dropdown
                            const Text(
                              "Floor",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(
                              () => _editDropdown<FloorModel>(
                                value: selectedFloor.value,
                                items: hostelCtrl.floorModels,
                                hint: "Select Floor",
                                displayFn: (f) => f.floorName,
                                onChanged: (v) {
                                  selectedFloor.value = v;
                                  selectedRoom.value = null;
                                  if (v != null) {
                                    hostelCtrl.loadRoomsByFloor(v.id);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Room dropdown
                            const Text(
                              "Room",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(
                              () => _editDropdown<RoomModel>(
                                value: selectedRoom.value,
                                items: hostelCtrl.roomModels,
                                hint: "Select Room",
                                displayFn: (r) => r.roomName,
                                onChanged: (v) => selectedRoom.value = v,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---- Update Button ----
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: MediaQuery.of(dialogContext).padding.bottom + 16,
                ),
                child: Obx(
                  () => GestureDetector(
                    onTap:
                        (selectedHostel.value == null ||
                            selectedFloor.value == null ||
                            selectedRoom.value == null ||
                            hostelCtrl.isLoading.value)
                        ? null
                        : () async {
                            final message = await hostelCtrl.updateHostelMember(
                              sid: (data['sid'] ?? data['id'] ?? '').toString(),
                              branch: selectedBranchId.value?.toString() ?? "",
                              hostel: selectedHostel.value!.id.toString(),
                              floor: selectedFloor.value!.id.toString(),
                              room: selectedRoom.value!.id.toString(),
                              month: "March", // Consistency with add page
                            );
                            if (message != null) {
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: primaryPurple,
                                ),
                              );
                              // Refresh members list
                              String type = "";
                              String param = "";
                              if (selectedCategory.value == "Hostel Wise") {
                                type = "hostel";
                                param = selectedHostelId.value.toString();
                              } else if (selectedCategory.value ==
                                  "Floor Wise") {
                                type = "floor";
                                param = selectedFloorId.value.toString();
                              } else {
                                type = "room";
                                param = selectedRoomId.value.toString();
                              }
                              await hostelCtrl.fetchHostelMembers(
                                type: type,
                                param: param,
                              );
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient:
                            (selectedHostel.value == null ||
                                selectedFloor.value == null ||
                                selectedRoom.value == null ||
                                hostelCtrl.isLoading.value)
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFF7D74FC).withOpacity(0.5),
                                  const Color(0xFFD08EF7).withOpacity(0.5),
                                ],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: hostelCtrl.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Update Members",
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
        ),
      ),
    );
  }

  Widget _editDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required String Function(T) displayFn,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(
                displayFn(e),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 13.5),
        children: [
          TextSpan(
            text: "$label :  ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> data) {
    final String studentName =
        data['student_name']?.toString() ??
        data['name']?.toString() ??
        'this student';

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: const Icon(Icons.close, size: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE6E4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF6B6B),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Remove Member?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "Are you sure you want to remove\n"),
                    TextSpan(
                      text: "$studentName\n",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const TextSpan(text: "from this hostel?"),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final sid = (data['sid'] ?? data['id'] ?? '')
                              .toString();
                          if (sid.isEmpty) {
                            Get.snackbar("Error", "Student ID not found");
                            return;
                          }

                          final message = await hostelCtrl.removeHostelMember(
                            sid,
                          );
                          if (message != null) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: primaryPurple,
                              ),
                            );

                            // Refresh members list
                            String type = "";
                            String param = "";
                            if (selectedCategory.value == "Hostel Wise") {
                              type = "hostel";
                              param = selectedHostelId.value.toString();
                            } else if (selectedCategory.value == "Floor Wise") {
                              type = "floor";
                              param = selectedFloorId.value.toString();
                            } else {
                              type = "room";
                              param = selectedRoomId.value.toString();
                            }
                            await hostelCtrl.fetchHostelMembers(
                              type: type,
                              param: param,
                            );
                          }
                        },
                        child: const Text(
                          "Remove",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://cdni.iconscout.com/illustration/premium/thumb/searching-concept-illustration-download-in-svg-png-gif-file-formats--person-magnifying-glass-data-find-pack-business-illustrations-4712431.png",
            height: 200,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Please select a branch to view categories",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 13),
        children: [
          TextSpan(
            text: "$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _squareIcon({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
