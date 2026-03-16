// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:student_app/staff_app/controllers/batch_controller.dart';
// import 'package:student_app/staff_app/controllers/branch_controller.dart';
// import 'package:student_app/staff_app/controllers/course_controller.dart';
// import 'package:student_app/staff_app/controllers/group_controller.dart';
// import 'package:student_app/admin_app/admin_header.dart';

// class AddAssignmentsPage extends StatefulWidget {
//   const AddAssignmentsPage({super.key});

//   @override
//   State<AddAssignmentsPage> createState() => _AddAssignmentsPageState();
// }

// class _AddAssignmentsPageState extends State<AddAssignmentsPage> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   final BranchController branchCtrl = Get.put(BranchController());
//   final GroupController groupCtrl = Get.put(GroupController());
//   final CourseController courseCtrl = Get.put(CourseController());
//   final BatchController batchCtrl = Get.put(BatchController());

//   String? selectedBranch;
//   String? selectedGroup;
//   String? selectedCourse;
//   String? selectedBatch;
//   String? selectedSubject;

//   final List<String> subjects = [
//     "Mathematics",
//     "Physics",
//     "Chemistry",
//     "Biology",
//     "English",
//     "Social Studies",
//     "Computer Science",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     branchCtrl.loadBranches();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       body: Column(
//         children: [
//           /// HEADER
//           const AdminHeader(title: "Add Assignments"),

//           const SizedBox(height: 20),

//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 18),
//               child: Container(
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   color: const Color(0xffE6DFF3),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Column(
//                   children: [
//                     /// HOMEWORK TITLE
//                     buildTextField(
//                       "Homework Title",
//                       "Enter Homework Title",
//                       titleController,
//                     ),

//                     /// BRANCH
//                     Obx(
//                       () => buildDropdown(
//                         "Branch",
//                         "Select Branch",
//                         selectedBranch,
//                         branchCtrl.branches.map((e) => e.branchName).toList(),
//                         (val) {
//                           setState(() {
//                             selectedBranch = val;
//                             selectedGroup = null;
//                             selectedCourse = null;
//                             selectedBatch = null;
//                           });
//                           final b = branchCtrl.branches.firstWhere(
//                             (e) => e.branchName == val,
//                           );
//                           groupCtrl.loadGroups(b.id);
//                         },
//                       ),
//                     ),

//                     /// GROUP
//                     Obx(
//                       () => buildDropdown(
//                         "Group",
//                         "Select Group",
//                         selectedGroup,
//                         groupCtrl.groups.map((e) => e.name).toList(),
//                         (val) {
//                           setState(() {
//                             selectedGroup = val;
//                             selectedCourse = null;
//                             selectedBatch = null;
//                           });
//                           final g = groupCtrl.groups.firstWhere(
//                             (e) => e.name == val,
//                           );
//                           courseCtrl.loadCourses(g.id);
//                         },
//                       ),
//                     ),

//                     /// COURSE
//                     Obx(
//                       () => buildDropdown(
//                         "Course",
//                         "Select Course",
//                         selectedCourse,
//                         courseCtrl.courses.map((e) => e.courseName).toList(),
//                         (val) {
//                           setState(() {
//                             selectedCourse = val;
//                             selectedBatch = null;
//                           });
//                           final c = courseCtrl.courses.firstWhere(
//                             (e) => e.courseName == val,
//                           );
//                           batchCtrl.loadBatches(c.id);
//                         },
//                       ),
//                     ),

//                     /// BATCH
//                     Obx(
//                       () => buildDropdown(
//                         "Batch",
//                         "Select Batch",
//                         selectedBatch,
//                         batchCtrl.batches.map((e) => e.batchName).toList(),
//                         (val) => setState(() => selectedBatch = val),
//                       ),
//                     ),

//                     /// SUBJECT
//                     buildDropdown(
//                       "Subject",
//                       "Select Subject",
//                       selectedSubject,
//                       subjects,
//                       (val) => setState(() => selectedSubject = val),
//                     ),

//                     /// DESCRIPTION
//                     buildDescription(),

//                     const SizedBox(height: 20),

//                     /// BUTTON
//                     GestureDetector(
//                       onTap: () {
//                         if (titleController.text.isEmpty ||
//                             selectedBranch == null ||
//                             selectedGroup == null ||
//                             selectedCourse == null ||
//                             selectedBatch == null ||
//                             selectedSubject == null ||
//                             descriptionController.text.isEmpty) {
//                           Get.snackbar(
//                             "Warning",
//                             "Please fill all required fields",
//                             backgroundColor: Colors.orange.shade100,
//                           );
//                           return;
//                         }

//                         // Simulate saving
//                         Get.snackbar(
//                           "Success",
//                           "Homework assigned successfully",
//                           backgroundColor: Colors.green.shade100,
//                         );
//                         Future.delayed(const Duration(seconds: 1), () {
//                           Get.back();
//                         });
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Color(0xff6A5AE0), Color(0xffB06AB3)],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "Assign Homework",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// TEXT FIELD
//   Widget buildTextField(
//     String label,
//     String hint,
//     TextEditingController controller,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//             children: const [
//               TextSpan(
//                 text: " *",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 6),

//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),

//         const SizedBox(height: 14),
//       ],
//     );
//   }

//   /// DROPDOWN
//   Widget buildDropdown(
//     String label,
//     String hint,
//     String? value,
//     List<String> items,
//     Function(String?) onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//             children: const [
//               TextSpan(
//                 text: " *",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 6),

//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: value,
//             hint: Text(hint),
//             isExpanded: true,
//             decoration: const InputDecoration(border: InputBorder.none),
//             items: items.map((String item) {
//               return DropdownMenuItem<String>(value: item, child: Text(item));
//             }).toList(),
//             onChanged: onChanged,
//           ),
//         ),

//         const SizedBox(height: 14),
//       ],
//     );
//   }

//   /// DESCRIPTION BOX
//   Widget buildDescription() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: const TextSpan(
//             text: "Homework Content / Description",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//             children: [
//               TextSpan(
//                 text: " *",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 6),

//         TextField(
//           controller: descriptionController,
//           maxLines: 6,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/controllers/add_homework.dart';

class AddAssignmentsPage extends StatefulWidget {
  const AddAssignmentsPage({super.key});

  @override
  State<AddAssignmentsPage> createState() => _AddAssignmentsPageState();
}

class _AddAssignmentsPageState extends State<AddAssignmentsPage> {
  final AddHomeworkController controller = Get.put(AddHomeworkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          /// HEADER
          const AdminHeader(title: "Add Assignments"),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffE6DFF3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    /// HOMEWORK TITLE
                    buildTextField(
                      "Homework Title",
                      "Enter Homework Title",
                      controller.titleController,
                    ),

                    /// BRANCH
                    Obx(
                      () => buildDropdown(
                        "Branch",
                        "Select Branch",
                        controller.branchCtrl.selectedBranch.value?.branchName,
                        controller.branchCtrl.branches
                            .map((e) => e.branchName)
                            .toList(),
                        (val) {
                          final b = controller.branchCtrl.branches.firstWhere(
                            (e) => e.branchName == val,
                          );
                          controller.branchCtrl.selectedBranch.value = b;
                        },
                      ),
                    ),

                    /// GROUP
                    Obx(
                      () => buildDropdown(
                        "Group",
                        "Select Group",
                        controller.groupCtrl.selectedGroup.value?.name,
                        controller.groupCtrl.groups.map((e) => e.name).toList(),
                        (val) {
                          final g = controller.groupCtrl.groups.firstWhere(
                            (e) => e.name == val,
                          );
                          controller.groupCtrl.selectedGroup.value = g;
                        },
                      ),
                    ),

                    /// COURSE
                    Obx(
                      () => buildDropdown(
                        "Course",
                        "Select Course",
                        controller.courseCtrl.selectedCourse.value?.courseName,
                        controller.courseCtrl.courses
                            .map((e) => e.courseName)
                            .toList(),
                        (val) {
                          final c = controller.courseCtrl.courses.firstWhere(
                            (e) => e.courseName == val,
                          );
                          controller.courseCtrl.selectedCourse.value = c;
                        },
                      ),
                    ),

                    /// BATCH
                    Obx(
                      () => buildDropdown(
                        "Batch",
                        "Select Batch",
                        controller.batchCtrl.selectedBatch.value?.batchName,
                        controller.batchCtrl.batches
                            .map((e) => e.batchName)
                            .toList(),
                        (val) {
                          final b = controller.batchCtrl.batches.firstWhere(
                            (e) => e.batchName == val,
                          );
                          controller.batchCtrl.selectedBatch.value = b;
                        },
                      ),
                    ),

                    /// SUBJECT
                    Obx(
                      () => buildDropdown(
                        "Subject",
                        "Select Subject",
                        controller.selectedSubject.value?.subjectName,
                        controller.subjects.map((e) => e.subjectName).toList(),
                        (val) {
                          final s = controller.subjects.firstWhere(
                            (e) => e.subjectName == val,
                          );
                          controller.selectedSubject.value = s;
                        },
                        isLoading: controller.isLoadingSubjects.value,
                      ),
                    ),

                    /// DESCRIPTION
                    buildDescription(),

                    const SizedBox(height: 20),

                    /// BUTTON
                    Obx(
                      () => GestureDetector(
                        onTap: controller.isSaving.value
                            ? null
                            : () => controller.saveHomework(),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: controller.isSaving.value
                                  ? [Colors.grey, Colors.grey]
                                  : [
                                      const Color(0xff6A5AE0),
                                      const Color(0xffB06AB3),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: controller.isSaving.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Assign Homework",
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
          ),
        ],
      ),
    );
  }

  /// TEXT FIELD
  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  /// DROPDOWN
  Widget buildDropdown(
    String label,
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : DropdownButtonFormField<String>(
                  value: value,
                  hint: Text(hint),
                  isExpanded: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  /// DESCRIPTION BOX
  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: "Homework Content / Description",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.descriptionController,
          maxLines: 6,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
