import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../api/api_collection.dart';
import '../model/branch_model.dart';
import '../model/hostel_model.dart';
import '../model/floor_incharge_model.dart';
import '../model/floor_model.dart';
import '../model/room_model.dart';

class AssignInchargeController extends GetxController {
  // Observables for dropdown data
  final RxList<BranchModel> branches = <BranchModel>[].obs;
  final RxList<HostelModel> hostels = <HostelModel>[].obs;
  final RxList<FloorInchargeModel> incharges = <FloorInchargeModel>[].obs;
  final RxList<FloorModel> floors = <FloorModel>[].obs;
  final RxList<RoomModel> rooms = <RoomModel>[].obs;

  // Selected values (observables)
  final Rxn<BranchModel> selectedBranch = Rxn<BranchModel>();
  final Rxn<HostelModel> selectedHostel = Rxn<HostelModel>();
  final Rxn<FloorInchargeModel> selectedIncharge = Rxn<FloorInchargeModel>();
  final Rxn<FloorModel> selectedFloor = Rxn<FloorModel>();
  final RxList<RoomModel> selectedRooms = <RoomModel>[].obs;

  // Loading states
  final RxBool isBranchesLoading = false.obs;
  final RxBool isHostelsLoading = false.obs;
  final RxBool isInchargesLoading = false.obs;
  final RxBool isFloorsLoading = false.obs;
  final RxBool isRoomsLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
  }

  // ================= FETCHING DATA =================

  Future<void> fetchBranches() async {
    try {
      isBranchesLoading.value = true;
      final res = await ApiService.getRequest(ApiCollection.branchList);
      if (res["success"] == true || res["success"] == "true") {
        branches.value = (res["indexdata"] as List)
            .map((e) => BranchModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching branches: $e");
    } finally {
      isBranchesLoading.value = false;
    }
  }

  Future<void> fetchHostels(int branchId) async {
    try {
      isHostelsLoading.value = true;
      hostels.clear();
      selectedHostel.value = null;
      floors.clear();
      selectedFloor.value = null;
      incharges.clear();
      selectedIncharge.value = null;
      rooms.clear();
      selectedRooms.clear();

      final results = await ApiService.getHostelsByBranch(branchId);
      hostels.value = results.map((e) => HostelModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching hostels: $e");
    } finally {
      isHostelsLoading.value = false;
    }
  }

  Future<void> fetchInchargesAndFloors(int buildingId) async {
    try {
      isInchargesLoading.value = true;
      isFloorsLoading.value = true;
      incharges.clear();
      selectedIncharge.value = null;
      floors.clear();
      selectedFloor.value = null;
      rooms.clear();
      selectedRooms.clear();

      // Fetch Incharges
      final inchargeResults = await ApiService.getFloorIncharges(buildingId);
      incharges.value =
          inchargeResults.map((e) => FloorInchargeModel.fromJson(e)).toList();

      // Fetch Floors
      final floorResults = await ApiService.getFloorsByHostel(buildingId);
      floors.value = floorResults.map((e) => FloorModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching incharges/floors: $e");
    } finally {
      isInchargesLoading.value = false;
      isFloorsLoading.value = false;
    }
  }

  Future<void> fetchRooms(int floorId) async {
    try {
      isRoomsLoading.value = true;
      rooms.clear();
      selectedRooms.clear();

      final results = await ApiService.getRoomsByFloor(floorId);
      rooms.value = results.map((e) => RoomModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching rooms: $e");
    } finally {
      isRoomsLoading.value = false;
    }
  }

  // ================= ACTION =================

  Future<void> assignRoom() async {
    if (selectedBranch.value == null ||
        selectedHostel.value == null ||
        selectedIncharge.value == null ||
        selectedFloor.value == null ||
        selectedRooms.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields",
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }

    try {
      isSubmitting.value = true;
      final roomIds = selectedRooms.map((r) => r.id).toList();

      await ApiService.assignIncharge(
        branchId: selectedBranch.value!.id,
        hostelId: selectedHostel.value!.id,
        staffId: selectedIncharge.value!.id,
        floorId: selectedFloor.value!.id,
        rooms: roomIds,
      );

      Get.snackbar("Success", "Room Assigned Successfully",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      
      // Optionally reset form
      // resetForm();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedBranch.value = null;
    selectedHostel.value = null;
    selectedIncharge.value = null;
    selectedFloor.value = null;
    selectedRooms.clear();
    hostels.clear();
    incharges.clear();
    floors.clear();
    rooms.clear();
  }
}
