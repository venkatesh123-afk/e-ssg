import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';
import '../controllers/assign_incharge_controller.dart';
import '../model/branch_model.dart';
import '../model/hostel_model.dart';
import '../model/floor_incharge_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';

class AssignInchargePage extends StatefulWidget {
  const AssignInchargePage({super.key});

  @override
  State<AssignInchargePage> createState() => _AssignInchargePageState();
}

class _AssignInchargePageState extends State<AssignInchargePage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AssignInchargeController());

  // Constants
  static const Color lavenderBg = Color(0xFFF1F4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: "Assign Incharge"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ================= FORM CONTAINER =================
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: lavenderBg.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Branch"),
                            _buildGenericDropdown<BranchModel>(
                              hint: "Select Branch",
                              value: controller.selectedBranch.value,
                              items: controller.branches,
                              itemLabel: (b) => b.branchName,
                              onChanged: (v) {
                                controller.selectedBranch.value = v;
                                if (v != null) controller.fetchHostels(v.id);
                              },
                            ),

                            _buildLabel("Building"),
                            _buildGenericDropdown<HostelModel>(
                              hint: "Select Building",
                              value: controller.selectedHostel.value,
                              items: controller.hostels,
                              itemLabel: (h) => h.buildingName,
                              onChanged: (v) {
                                controller.selectedHostel.value = v;
                                if (v != null)
                                  controller.fetchInchargesAndFloors(v.id);
                              },
                            ),

                            _buildLabel("Incharge"),
                            _buildGenericDropdown<FloorInchargeModel>(
                              hint: "Select Incharge",
                              value: controller.selectedIncharge.value,
                              items: controller.incharges,
                              itemLabel: (i) => i.name,
                              onChanged: (v) =>
                                  controller.selectedIncharge.value = v,
                            ),

                            _buildLabel("Floor"),
                            _buildGenericDropdown<FloorModel>(
                              hint: "Select Floor",
                              value: controller.selectedFloor.value,
                              items: controller.floors,
                              itemLabel: (f) => f.floorName,
                              onChanged: (v) {
                                controller.selectedFloor.value = v;
                                if (v != null) controller.fetchRooms(v.id);
                              },
                            ),

                            _buildLabel("Assign Rooms"),
                            _buildGenericDropdown<RoomModel>(
                              hint: controller.isRoomsLoading.value
                                  ? "Loading rooms..."
                                  : "Select Room",
                              value: controller.selectedRooms.isNotEmpty
                                  ? controller.selectedRooms.first
                                  : null,
                              items: controller.rooms,
                              itemLabel: (r) => r.roomName,
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedRooms.clear();
                                  controller.selectedRooms.add(v);
                                }
                              },
                            ),

                            const SizedBox(height: 25),

                            // ================= ASSIGN ROOM BUTTON =================
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7D74FC),
                                    Color(0xFFD08EF7),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isSubmitting.value
                                    ? null
                                    : () => controller.assignRoom(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: controller.isSubmitting.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Assign Room",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
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
    );
  }

  Widget _buildGenericDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
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
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(
                itemLabel(e),
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
