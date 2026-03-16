import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;
  bool isStaff = true; // Visual toggle state

  late final AuthController auth;

  @override
  void initState() {
    super.initState();
    auth = Get.find<AuthController>();
    userCtrl.clear();
    passCtrl.clear();

    // Auto-toggle based on input length
    userCtrl.addListener(() {
      final text = userCtrl.text.trim();
      if (text.length == 10) {
        if (isStaff) setState(() => isStaff = false);
      } else if (text.length == 6) {
        if (!isStaff) setState(() => isStaff = true);
      }
    });
  }

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---------------- BACKGROUND DECORATIONS ----------------
          Positioned(
            top: -150,
            left: -107,
            child: _buildBlob(324, [
              const Color(0xFFC98CF8),
              const Color(0xFF8275FB),
            ]),
          ),
          Positioned(
            top: -180,
            left: 156,
            child: _buildBlob(270, [
              const Color(0xFFC98CF8),
              const Color(0xFF8275FB),
            ]),
          ),
          Positioned(
            top: 603,
            left: 225,
            child: _buildBlob(306, [
              const Color(0xFFC98CF8),
              const Color(0xFF8275FB),
            ]),
          ),
          Positioned(
            top: 600,
            left: 195,
            child: _buildBlob(56, [
              const Color(0xFFC98CF8),
              const Color(0xFF8275FB),
            ]),
          ),

          // ---------------- CONTENT ----------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // ---------------- LOGIN CARD ----------------
                    Container(
                      constraints: const BoxConstraints(maxWidth: 358),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Welcome to SSJC!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ---------- USERNAME ----------
                          const Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: userCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your email address",
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ---------- PASSWORD ----------
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: passCtrl,
                              obscureText: obscure,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 13,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      setState(() => obscure = !obscure),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ---------- FORGOT PASSWORD ----------
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {}, // Logic not added as requested
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Color(0xFFFA577F),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ---------- SIGN IN BUTTON ----------
                          Obx(
                            () => Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B64FE),
                                    Color(0xFFD68AF9),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8A2BE2,
                                    ).withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: auth.isLoading.value
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        final username = userCtrl.text.trim();
                                        final password = passCtrl.text.trim();

                                        if (username.isEmpty ||
                                            password.isEmpty) {
                                          Get.snackbar(
                                            "Error",
                                            "Please enter username & password",
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        if (username.length != 6 &&
                                            username.length != 10) {
                                          Get.snackbar(
                                            "Invalid Input",
                                            "Username must be 6 digits (Staff) or 10 digits (Student)",
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        await auth.login(username, password);
                                      },
                                child: auth.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Sign In",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
          colors: colors,
        ),
      ),
    );
  }
}
