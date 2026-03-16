import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';
import '../api/api_service.dart';
import '../controllers/add_hostel_members_controller.dart';
import '../model/hostel_student_model.dart';
import '../model/hostel_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';

class AddHostelMembersPage extends StatelessWidget {
  const AddHostelMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddHostelMembersController());
    const Color primaryPurple = Color(0xFF7E49FF);
    const Color lavenderBg = Color(0xFFF1F4FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: "Add Hostel Members"),

          Obx(
            () => Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ================= CONTENT CONTAINER =================
                    if (!controller.showData.value)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: lavenderBg.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Branch"),
                            Obx(
                              () => _buildDropdown<dynamic>(
                                hint: "Select Branch",
                                value:
                                    controller.branchCtrl.selectedBranch.value,
                                items: controller.branchCtrl.branches,
                                displayFn: (v) => v.branchName,
                                onChanged: (v) =>
                                    controller.branchCtrl.selectedBranch.value =
                                        v,
                              ),
                            ),

                            _buildLabel("Group"),
                            Obx(
                              () => _buildDropdown<dynamic>(
                                hint: "Select Group",
                                value: controller.groupCtrl.selectedGroup.value,
                                items: controller.groupCtrl.groups,
                                displayFn: (v) => v.groupName,
                                onChanged: (v) =>
                                    controller.groupCtrl.selectedGroup.value =
                                        v,
                              ),
                            ),

                            _buildLabel("Course"),
                            Obx(
                              () => _buildDropdown<dynamic>(
                                hint: "Select Course",
                                value:
                                    controller.courseCtrl.selectedCourse.value,
                                items: controller.courseCtrl.courses,
                                displayFn: (v) => v.courseName,
                                onChanged: (v) =>
                                    controller.courseCtrl.selectedCourse.value =
                                        v,
                              ),
                            ),

                            _buildLabel("Batch"),
                            Obx(
                              () => _buildDropdown<dynamic>(
                                hint: "Select Batch",
                                value: controller.batchCtrl.selectedBatch.value,
                                items: controller.batchCtrl.batches,
                                displayFn: (v) => v.batchName,
                                onChanged: (v) =>
                                    controller.batchCtrl.selectedBatch.value =
                                        v,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ================= GET STUDENT BUTTON =================
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7D74FC),
                                    Color(0xFFD08EF7),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isLoadingStudents.value
                                    ? null
                                    : () => controller.fetchStudents(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: controller.isLoadingStudents.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Get Student",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _cardDropdownRow<HostelModel>(
                                  "Hostel",
                                  controller.globalHostel,
                                  "Select Hostel",
                                  controller.hostelCtrl.hostels,
                                  (v) => v?.buildingName ?? "",
                                  (v) async {
                                    controller.globalHostel.value = v;
                                    controller.globalFloor.value = null;
                                    controller.globalRoom.value = null;
                                    controller.globalFloors.clear();
                                    if (v != null) {
                                      final data =
                                          await ApiService.getFloorsByHostel(
                                            v.id,
                                          );
                                      controller.globalFloors.assignAll(
                                        data
                                            .map((e) => FloorModel.fromJson(e))
                                            .toList(),
                                      );
                                    }
                                  },
                                ),
                                _cardDropdownRow<FloorModel>(
                                  "Floor",
                                  controller.globalFloor,
                                  "Select Floor",
                                  controller.globalFloors,
                                  (v) => v?.floorName ?? "",
                                  (v) async {
                                    controller.globalFloor.value = v;
                                    controller.globalRoom.value = null;
                                    controller.globalRooms.clear();
                                    if (v != null) {
                                      final data =
                                          await ApiService.getRoomsByFloor(
                                            v.id,
                                          );
                                      controller.globalRooms.assignAll(
                                        data
                                            .map((e) => RoomModel.fromJson(e))
                                            .toList(),
                                      );
                                    }
                                  },
                                ),
                                _cardDropdownRow<RoomModel>(
                                  "Room",
                                  controller.globalRoom,
                                  "Select Room",
                                  controller.globalRooms,
                                  (v) => v?.roomName ?? "",
                                  (v) => controller.globalRoom.value = v,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: lavenderBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: controller.students.asMap().entries.map(
                                (entry) {
                                  int i = entry.key;
                                  HostelStudentModel data = entry.value;
                                  return _buildStudentCard(controller, i, data);
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ================= SAVE MEMBERS BUTTON =================
          Obx(
            () => controller.showData.value
                ? Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3FAFB9), Color(0xFFAED160)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            bool anySaved = false;
                            for (var entry in controller.selections.entries) {
                              final student = controller.students
                                  .firstWhereOrNull((s) => s.sid == entry.key);
                              final selection = entry.value;

                              // Use individual selection or global selection
                              final hostelId =
                                  selection.selectedHostel.value?.id
                                      .toString() ??
                                  controller.globalHostel.value?.id.toString();
                              final floorId =
                                  selection.selectedFloor.value?.id
                                      .toString() ??
                                  controller.globalFloor.value?.id.toString();
                              final roomId =
                                  selection.selectedRoom.value?.id.toString() ??
                                  controller.globalRoom.value?.id.toString() ??
                                  "";

                              if (student != null &&
                                  hostelId != null &&
                                  floorId != null) {
                                await controller.saveHostelMember(
                                  student: student,
                                  hostelId: hostelId,
                                  floorId: floorId,
                                  room: roomId,
                                  month: "March", // Default or dynamic?
                                  showSnackbar: false,
                                );
                                anySaved = true;
                              }
                            }

                            if (anySaved) {
                              controller.reset();
                              Get.snackbar(
                                "Success",
                                "Members process completed",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: primaryPurple.withOpacity(0.8),
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                              );
                            } else {
                              Get.snackbar(
                                "Warning",
                                "No students selected with hostel/floor",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Add Hostel Members",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    AddHostelMembersController controller,
    int index,
    HostelStudentModel student,
  ) {
    final selection = controller.selections[student.sid];
    if (selection == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(
        bottom: index == controller.students.length - 1 ? 0 : 15,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "S.NO: ${index + 1}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Adm No : ${student.admno}",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),
          _infoRow("Student Name", student.studentName),
          const SizedBox(height: 8),
          _infoRow("Phone Number", student.phone ?? "N/A"),
          const SizedBox(height: 12),

          _cardDropdownRow<HostelModel>(
            "Hostel",
            selection.selectedHostel,
            "Select Hostel",
            controller.hostelCtrl.hostels,
            (v) => v?.buildingName ?? "",
            (v) async {
              selection.selectedHostel.value = v;
              selection.selectedFloor.value = null;
              selection.selectedRoom.value = null;
              selection.floors.clear();
              if (v != null) {
                final data = await ApiService.getFloorsByHostel(v.id);
                selection.floors.assignAll(
                  data.map((e) => FloorModel.fromJson(e)).toList(),
                );
              }
            },
          ),
          _cardDropdownRow<FloorModel>(
            "Floor",
            selection.selectedFloor,
            "Select Floor",
            selection.floors,
            (v) => v?.floorName ?? "",
            (v) async {
              selection.selectedFloor.value = v;
              selection.selectedRoom.value = null;
              selection.rooms.clear();
              if (v != null) {
                final data = await ApiService.getRoomsByFloor(v.id);
                selection.rooms.assignAll(
                  data.map((e) => RoomModel.fromJson(e)).toList(),
                );
              }
            },
          ),
          _cardDropdownRow<RoomModel>(
            "Room",
            selection.selectedRoom,
            "Select Room",
            selection.rooms,
            (v) => v?.roomName ?? "",
            (v) => selection.selectedRoom.value = v,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardDropdownRow<T>(
    String label,
    Rxn<T> value,
    String hint,
    List<T> items,
    String Function(T?) displayFn,
    Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<T>(
                    isExpanded: true,
                    isDense: true,
                    value: value.value,
                    hint: Text(
                      hint,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black87,
                    ),
                    items: items
                        .map(
                          (e) => DropdownMenuItem<T>(
                            value: e,
                            child: Text(
                              displayFn(e),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged,
                  ),
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
            fontWeight: FontWeight.w600,
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

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) displayFn,
    required void Function(T?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black87,
            size: 20,
          ),
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(
                displayFn(e),
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
