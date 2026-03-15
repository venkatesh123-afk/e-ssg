import 'package:flutter/material.dart';
import '../widgets/staff_header.dart';
import '../model/syllabus_model.dart';
import '../api/api_service.dart';

class TrackSyllabusProgressPage extends StatefulWidget {
  final SyllabusModel syllabus;
  const TrackSyllabusProgressPage({super.key, required this.syllabus});

  @override
  State<TrackSyllabusProgressPage> createState() =>
      _TrackSyllabusProgressPageState();
}

class _TrackSyllabusProgressPageState extends State<TrackSyllabusProgressPage> {
  late double progress;
  late String status;
  bool isLoading = false;
  bool isUpdating = false;
  late SyllabusModel currentSyllabus;

  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSyllabus = widget.syllabus;
    _initializeData();
    _fetchSyllabusDetails();
  }

  @override
  void dispose() {
    startDate.dispose();
    endDate.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _initializeData() {
    progress = currentSyllabus.progressPercent / 100;
    status = _getInitialStatus(currentSyllabus.trackingStatus);
    startDate.text = currentSyllabus.actualStartDate ?? "";
    endDate.text = currentSyllabus.actualCompletedDate ?? "";
    notesController.text = currentSyllabus.trackingRemarks ?? "";
  }

  Future<void> _fetchSyllabusDetails() async {
    try {
      setState(() => isLoading = true);
      final details = await ApiService.getSyllabusDetails(widget.syllabus.id);
      setState(() {
        currentSyllabus = details;
        _initializeData();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH SYLLABUS DETAILS ERROR: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _updateProgress() async {
    try {
      setState(() => isUpdating = true);

      int statusId = 1;
      if (status == "In Progress") statusId = 2;
      if (status == "Completed") statusId = 3;

      await ApiService.updateSyllabusProgress(
        id: currentSyllabus.id,
        actualStartDate: startDate.text.isNotEmpty ? startDate.text : null,
        actualCompletedDate: endDate.text.isNotEmpty ? endDate.text : null,
        progressPercent: progress * 100,
        trackingStatus: statusId,
        trackingRemarks: notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Progress updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _fetchSyllabusDetails();
      }
    } catch (e) {
      debugPrint("UPDATE PROGRESS ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update progress: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  String _getInitialStatus(int? statusId) {
    switch (statusId) {
      case 1:
        return "Not Started";
      case 2:
        return "In Progress";
      case 3:
        return "Completed";
      default:
        return "Not Started";
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff6A5AE0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// HEADER
          const StaffHeader(title: "Track Syllabus Progress"),

          const SizedBox(height: 15),

          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SUBJECT CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        border: const Border(
                          left: BorderSide(color: Colors.teal, width: 5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subject :  ${currentSyllabus.subjectName ?? 'N/A'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("Chapter Name :  ${currentSyllabus.chapterName}"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ACTUAL START DATE
                    buildDateField(
                      "Actual Start Date",
                      startDate,
                      "Expected : ${currentSyllabus.expectedStartDate}",
                      context,
                    ),

                    const SizedBox(height: 15),

                    /// ACTUAL END DATE
                    buildDateField(
                      "Actual Completion Date",
                      endDate,
                      "Expected : ${currentSyllabus.expectedAccomplishedDate}",
                      context,
                    ),

                    const SizedBox(height: 15),

                    /// PROGRESS SLIDER
                    const Text(
                      "Progress Percentage",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: progress,
                            onChanged: (value) {
                              setState(() {
                                progress = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${(progress * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("0% (Started)", style: TextStyle(fontSize: 10)),
                        Text("50% (Midway)", style: TextStyle(fontSize: 10)),
                        Text("100% (Completed)",
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// TRACKING STATUS
                    const Text(
                      "Tracking Status",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        buildStatusButton("Not Started", Colors.red),
                        const SizedBox(width: 10),
                        buildStatusButton("In Progress", Colors.orange),
                        const SizedBox(width: 10),
                        buildStatusButton("Completed", Colors.green),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// NOTES
                    const Text("Remarks / Notes"),

                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              "Enter Sessions Notes Or Reasons Foe Delay...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: isUpdating ? null : _updateProgress,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isUpdating
                                  ? [Colors.grey, Colors.grey]
                                  : [const Color(0xff6A5AE0), const Color(0xffB06AB3)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isUpdating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Update Progress",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// DATE FIELD
  Widget buildDateField(
    String label,
    TextEditingController controller,
    String expected,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),

        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => _selectDate(context, controller),
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xff6A5AE0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          expected,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// STATUS BUTTON
  Widget buildStatusButton(String text, Color color) {
    final bool isActive = status == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            status = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
