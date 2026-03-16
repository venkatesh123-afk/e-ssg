import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:student_app/staff_app/utils/iconify_icons.dart';

class AdminMainController extends GetxController {
  var currentIndex = 0.obs;
  void changeIndex(int index) => currentIndex.value = index;
}

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminMainController controller = Get.isRegistered<AdminMainController>()
        ? Get.find<AdminMainController>()
        : Get.put(AdminMainController(), permanent: true);

    return Obx(() {
      return Container(
        height: 90,
        padding: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(
          color: Color(0xFF7C3FE3), // Persistent Purple
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, IconifyIcons.baselineHouse, "Home", controller),
            _buildNavItem(
              1,
              IconifyIcons.graphBarIncrease,
              "Attendance",
              controller,
            ),
            _buildNavItem(
              2,
              IconifyIcons.feed32Filled,
              "Fees",
              controller,
            ),
            _buildNavItem(3, IconifyIcons.account, "Profile", controller),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem(
    int index,
    String icon,
    String label,
    AdminMainController controller,
  ) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        controller.changeIndex(index);

        switch (index) {
          case 0:
            Get.offAllNamed('/adminDashboard');
            break;
          case 1:
            Get.offAllNamed('/attendanceOptions');
            break;
          case 2:
            Get.offAllNamed('/feeHeads');
            break;
          case 3:
            Get.offAllNamed('/profile');
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
