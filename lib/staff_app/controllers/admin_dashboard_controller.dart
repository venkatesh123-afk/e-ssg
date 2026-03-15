import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/admin_dashboard_admissions_model.dart';
import '../model/admin_dashboard_finance_model.dart';
import '../model/admin_dashboard_attendance_model.dart';
import '../model/admin_dashboard_staff_model.dart';

class AdminDashboardController extends GetxController {
  var isLoading = false.obs;
  var admissionsData = AdminDashboardAdmissionsModel().obs;
  var financeData = AdminDashboardFinanceModel().obs;
  var attendanceData = AdminDashboardAttendanceModel().obs;
  var staffData = AdminDashboardStaffModel().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdmissionsData();
  }

  Future<void> fetchAdmissionsData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await ApiService.getAdminDashboardAdmissions();
      admissionsData(data);
    } catch (e) {
      errorMessage('Error: $e');
      print('AdminDashboardController Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchFinanceData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await ApiService.getAdminDashboardFinance();
      financeData(data);
    } catch (e) {
      errorMessage('Error: $e');
      print('AdminDashboardController Finance Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAttendanceData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await ApiService.getDashboardAttendance();
      attendanceData(data);
    } catch (e) {
      errorMessage('Error: $e');
      print('AdminDashboardController Attendance Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchStaffData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await ApiService.getAdminDashboardStaff();
      staffData(data);
    } catch (e) {
      errorMessage('Error: $e');
      print('AdminDashboardController Staff Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
