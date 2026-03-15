import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/admin_dashboard_attendance_model.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  final dashboardData = AdminDashboardAttendanceModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      final data = await ApiService.getDashboardAttendance();
      dashboardData.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  String get staffCount =>
      (dashboardData.value.infodata?.staffCount ?? 0).toString();
  String get studentAttendanceCount =>
      (dashboardData.value.infodata?.studentAttendanceCount ?? 0).toString();
  String get totalTodaysOutingCount =>
      (dashboardData.value.infodata?.totalTodaysOutingCount ?? 0).toString();
  String get staffAttendanceCount =>
      (dashboardData.value.infodata?.staffAttendanceCount ?? 0).toString();

  List<AttendanceClassSummary> get classAttendanceSummary =>
      dashboardData.value.infodata?.classAttendanceSummary ?? [];
}
