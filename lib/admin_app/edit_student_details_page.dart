import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditStudentDetailsPage extends StatefulWidget {
  const EditStudentDetailsPage({super.key});

  @override
  State<EditStudentDetailsPage> createState() => _EditStudentDetailsPageState();
}

class _EditStudentDetailsPageState extends State<EditStudentDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  final TextEditingController proController = TextEditingController(
    text: 'BALA VENKATESH',
  );
  final TextEditingController proPhoneController = TextEditingController(
    text: '7981820340',
  );
  final TextEditingController appNumberController = TextEditingController(
    text: '992491',
  );
  final TextEditingController branchController = TextEditingController(
    text: 'SSJC-ADARSA CAMPU',
  );
  final TextEditingController groupsController = TextEditingController(
    text: 'JR MPC',
  );
  final TextEditingController courseController = TextEditingController(
    text: 'IIT',
  );
  final TextEditingController batchController = TextEditingController(
    text: 'ADA-JR-B1',
  );
  final TextEditingController firstNameController = TextEditingController(
    text: 'USTUMURI',
  );
  final TextEditingController lastNameController = TextEditingController(
    text: 'RAMAKRISHNA REDDY',
  );
  final TextEditingController fatherNameController = TextEditingController(
    text: 'AMARENDRA',
  );
  final TextEditingController motherNameController = TextEditingController(
    text: 'LAKSHMIKUMARI',
  );
  final TextEditingController casteController = TextEditingController(
    text: 'OC',
  );
  final TextEditingController subcasteController = TextEditingController(
    text: 'REDDY',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField('PRO', proController, isFilledGrey: false),
                    _buildInputField(
                      'PRO Phone *',
                      proPhoneController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'Application Number *',
                      appNumberController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'Branch *',
                      branchController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'Groups *',
                      groupsController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'Course *',
                      courseController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'Batch *',
                      batchController,
                      isFilledGrey: true,
                    ),
                    _buildInputField(
                      'First Name *',
                      firstNameController,
                      isFilledGrey: false,
                    ),
                    _buildInputField(
                      'Last Name',
                      lastNameController,
                      isFilledGrey: false,
                    ),
                    _buildInputField(
                      'Father\'s Name *',
                      fatherNameController,
                      isFilledGrey: false,
                    ),
                    _buildInputField(
                      'Mother\'s Name',
                      motherNameController,
                      isFilledGrey: false,
                    ),
                    _buildInputField(
                      'Caste',
                      casteController,
                      isFilledGrey: false,
                    ),
                    _buildInputField(
                      'Subcaste',
                      subcasteController,
                      isFilledGrey: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Student details updated successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF7E49FF),
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7E49FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Update Admission',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 25,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E54FF), Color(0xFF7E49FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            'Edit Student',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    required bool isFilledGrey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: isFilledGrey
                    ? const Color(0xFFF2F2F2)
                    : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF7E49FF),
                    width: 1.5,
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
