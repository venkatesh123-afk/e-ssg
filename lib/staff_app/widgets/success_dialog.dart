import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final int total;
  final int present;
  final int absent;
  final int missing;
  final int outing;
  final int homePass;
  final int selfOuting;
  final int selfHome;
  final VoidCallback onConfirm;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.total,
    required this.present,
    required this.absent,
    this.missing = 0,
    this.outing = 0,
    this.homePass = 0,
    this.selfOuting = 0,
    this.selfHome = 0,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 24,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Green Check Icon ──
                  Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A7B20), // Dark green matching image
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Title ──
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Message ──
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ── Stats Row (3 Columns) ──
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                    children: [
                      _statCard(
                        context,
                        "Total",
                        total.toString(),
                        const Color(0xFF7E49FF), // Purple
                        const Color(0xFFF5F3FF),
                      ),
                      _statCard(
                        context,
                        "Present",
                        present.toString(),
                        const Color(0xFF10B981), // Green
                        const Color(0xFFECFDF5),
                      ),
                      _statCard(
                        context,
                        "Absent",
                        absent.toString(),
                        const Color(0xFFEF4444), // Red
                        const Color(0xFFFEF2F2),
                      ),
                      _statCard(
                        context,
                        "Missing",
                        missing.toString(),
                        const Color(0xFFF97316), // Orange
                        const Color(0xFFFFF7ED),
                      ),
                      _statCard(
                        context,
                        "Outing",
                        outing.toString(),
                        const Color(0xFF06B6D4), // Cyan
                        const Color(0xFFECFEFF),
                      ),
                      _statCard(
                        context,
                        "Home Pass",
                        homePass.toString(),
                        const Color(0xFFF59E0B), // Amber
                        const Color(0xFFFFFBEB),
                      ),
                      _statCard(
                        context,
                        "Self Out",
                        selfOuting.toString(),
                        const Color(0xFFA855F7), // Purple/Violet
                        const Color(0xFFFAF5FF),
                      ),
                      _statCard(
                        context,
                        "Self Home",
                        selfHome.toString(),
                        const Color(0xFFEC4899), // Pink
                        const Color(0xFFFDF2F8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ── OK Action Button ──
                  InkWell(
                    onTap: onConfirm,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7D74FC), Color(0xFFD08EF7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7D74FC).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Close 'X' Button ──
            Positioned(
              top: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
