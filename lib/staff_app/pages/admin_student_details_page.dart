import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/staff_header.dart';
import 'collect_fee_page.dart';
import 'edit_student_details_page.dart';


class AdminStudentDetailsPage extends StatefulWidget {
  const AdminStudentDetailsPage({super.key});

  @override
  State<AdminStudentDetailsPage> createState() =>
      _AdminStudentDetailsPageState();
}

class _AdminStudentDetailsPageState extends State<AdminStudentDetailsPage> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const StaffHeader(title: 'Student Details'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildProfileCard(),
                  const SizedBox(height: 25),
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  if (_activeTabIndex == 0) _buildProfileBody(),
                  if (_activeTabIndex == 1) _buildClassAttendanceBody(),
                  if (_activeTabIndex == 2) _buildHostelAttendanceBody(),
                  if (_activeTabIndex == 3) _buildDocumentsBody(),
                  if (_activeTabIndex == 4) _buildRemarksBody(),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButtons(),
    );
  }

  Widget _buildProfileBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Student details :'),
        _buildDetailsCard([
          _buildInfoRow('FULL NAME :', 'USTUMURI RAMAKRISHNA REDDY'),
          _buildInfoRow('DOB :', '2009-04-06'),
          _buildInfoRow('GENDER :', 'MALE'),
          _buildInfoRow('CASTE :', 'OC'),
          _buildInfoRow('SUB CASTE :', 'REDDY'),
          _buildInfoRow('AADHAR NO. :', '6785-5076-8434'),
          _buildInfoRow('PRIMARY MOBILE :', '------'),
          _buildInfoRow('ALTERNATE MOBILE :', '---------'),
          _buildInfoRow('FATHER NAME :', 'AMARENDRA'),
          _buildInfoRow('MOTHER NAME :', 'LAKSHMIKUMARI'),
          _buildInfoRow('MANDAL :', 'KANIGIRI'),
          _buildInfoRow('VILLAGE :', 'KANIGIRI'),
          _buildInfoRow('ADDRESS :', 'KANIGIRI'),
          _buildInfoRow('10GPA :', '591'),
        ]),
        const SizedBox(height: 20),
        _buildSectionTitle('Course details :'),
        _buildDetailsCard([
          _buildInfoRow('BRANCH :', 'SSJC-ADARSA CAMPUS'),
          _buildInfoRow('GROUP :', 'JR MPC'),
          _buildInfoRow('COURSE :', 'IIT'),
          _buildInfoRow('BATCH :', 'ADA-JR-B1'),
          _buildInfoRow('Admission Details :', 'REDDY'),
        ]),
        const SizedBox(height: 20),
        _buildSectionTitle('Admission Details :'),
        _buildDetailsCard([
          _buildInfoRow('ADMISSION NO. :', '252148'),
          _buildInfoRow('ADMISSION DATE :', '2025-05-28'),
          _buildInfoRow('ACTUAL FEE :', '150000'),
          _buildInfoRow('FEE STATUS :', 'NOT COMMITTED'),
          _buildInfoRow('ADMISSION STATUS :', 'CONVERTED'),
          _buildInfoRow('APPLICATION NO. :', '992491'),
          _buildInfoRow('ADMINSSION TYPE :', 'Hostel'),
          _buildInfoRow('COMMITTED FEE :', '150000'),
          _buildInfoRow('APPLICATION STATUS :', 'APPROVED'),
          _buildInfoRow('REMARKS :', '---'),
        ]),
      ],
    );
  }

  Widget _buildClassAttendanceBody() {
    return Column(
      children: [
        _buildAttendanceCard('Jun 25', 1, 1, 0),
        const SizedBox(height: 15),
        _buildAttendanceCard('Jul 25', 14, 14, 0),
        const SizedBox(height: 15),
        _buildAttendanceCard('Aug 25', 1, 1, 0),
        const SizedBox(height: 15),
        _buildAttendanceCard('Aug 25', 1, 1, 0),
        const SizedBox(height: 15),
        _buildAttendanceCard('Aug 25', 1, 1, 0),
      ],
    );
  }

  Widget _buildHostelAttendanceBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Hostel Name',
                'ADARSA',
                const Color(0xFF6B7AF5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                'Floor',
                '3RD FLOOR A & B BLOCKS',
                const Color(0xFFFF9F43),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Room',
                'A-303',
                const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                'Incharge Name',
                'SUBBISETTI SASI KIRAN',
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildClassAttendanceBody(),
      ],
    );
  }

  Widget _buildDocumentsBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('View Documents:'),
        _buildDetailsCard([
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admission Letter',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '20 MB',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ]),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF7E49FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Add Documents',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Remarks History:'),
        _buildDetailsCard([
          _buildInfoRow('S.No :', ''),
          _buildInfoRow('Date :', ''),
          _buildInfoRow('Category :', ''),
          _buildInfoRow('Remark :', ''),
          _buildInfoRow('Added By :', ''),
        ]),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF7E49FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Add Remark',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(String month, int wd, int pd, int ad) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$month :',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                8,
                (index) => _buildAttendanceIndicator(index + 1),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildAttendanceFooter('WD', wd),
              const SizedBox(width: 8),
              _buildVerticalDivider(),
              const SizedBox(width: 8),
              _buildAttendanceFooter('PD', pd),
              const SizedBox(width: 8),
              _buildVerticalDivider(),
              const SizedBox(width: 8),
              _buildAttendanceFooter('AD', ad),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceIndicator(int period) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$period',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF6DBB6D),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(IconData icon, String title, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 14,
      width: 1,
      color: Colors.black.withOpacity(0.15),
    );
  }

  Widget _buildAttendanceFooter(String label, int count) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.black54),
        children: [
          TextSpan(text: '$label : ', style: const TextStyle(fontWeight: FontWeight.w400)),
          TextSpan(text: ' $count', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.to(() => const EditStudentDetailsPage());
                      }
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert, color: Colors.black, size: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    itemBuilder: (context) => [
                      _buildPopupMenuItem(Icons.edit_outlined, 'Edit', 'edit'),
                      _buildPopupMenuItem(Icons.badge_outlined, 'Issue Conduct', 'conduct'),
                      _buildPopupMenuItem(Icons.print_outlined, 'Print Admission Form', 'print'),
                      _buildPopupMenuItem(Icons.check, 'Student Already Alloted', 'alloted'),
                    ],
                  ),
                ],
              ),
              const Text(
                'USTUMURI RAMAKRISHNA REDDY',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                  children: [
                    TextSpan(text: 'Admission No : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' 252126', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTag('JR MPC', const Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  _buildTag('IIT', const Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  _buildTag('ADA-JR-B1', const Color(0xFF2E7D32)),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF7E49FF),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab('Profile', _activeTabIndex == 0, () => setState(() => _activeTabIndex = 0)),
          _buildTab('Class Attendance', _activeTabIndex == 1, () => setState(() => _activeTabIndex = 1)),
          _buildTab('Hostel Attendance', _activeTabIndex == 2, () => setState(() => _activeTabIndex = 2)),
          _buildTab('Documents', _activeTabIndex == 3, () => setState(() => _activeTabIndex = 3)),
          _buildTab('Remarks', _activeTabIndex == 4, () => setState(() => _activeTabIndex = 4)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 25),
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF7E49FF), width: 2),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF7E49FF) : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDetailsCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Get.to(
                  () => const CollectFeePage(
                    studentName: 'USTUMURI RAMAKRISHNA REDDY',
                  ),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB388FF), Color(0xFF9575CD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Collect Tution Fee',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.snackbar(
                  "Fee Info",
                  "Student Due Fee Information",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF6DBB6D),
                  colorText: Colors.white,
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4DB6AC), Color(0xFF81C784)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Due Fee Info',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
