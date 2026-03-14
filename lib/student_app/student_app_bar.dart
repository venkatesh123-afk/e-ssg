import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_app/staff_app/pages/login_page.dart';
import 'package:student_app/student_app/change_password_page.dart';
import 'package:student_app/student_app/profile_page.dart';
import 'package:student_app/student_app/services/session_service.dart';
import 'package:student_app/student_app/services/student_profile_service.dart';
import 'package:student_app/student_app/studentdrawer.dart';

class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;

  const StudentAppBar({super.key, this.title = '', this.showLeading = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title.isNotEmpty ? Text(title) : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      leading: showLeading
          ? Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StudentDrawerPage(),
                    ),
                  );
                },
              ),
            )
          : null,
      actions: [
        // Profile Menu
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ValueListenableBuilder<String?>(
              valueListenable: StudentProfileService.profileImageUrl,
              builder: (context, imageUrl, _) {
                final isBase64 =
                    imageUrl != null && imageUrl.startsWith('data:image');
                return CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                      ? (isBase64
                                ? MemoryImage(
                                    base64Decode(imageUrl.split(',').last),
                                  )
                                : NetworkImage(imageUrl))
                            as ImageProvider
                      : null,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? Icon(
                          Icons.person,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                );
              },
            ),
            itemBuilder: (context) => [
              // Header Item (Welcome Message)
              PopupMenuItem<String>(
                enabled: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: StudentProfileService.displayName,
                    builder: (context, name, _) {
                      return Text(
                        "Welcome ${name ?? 'Student'}!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Profile
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 22,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                    const SizedBox(width: 12),
                    const Text("Profile"),
                  ],
                ),
              ),
              // Change Password
              PopupMenuItem<String>(
                value: 'password',
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 22,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                    const SizedBox(width: 12),
                    const Text("Change Password"),
                  ],
                ),
              ),

              // Logout
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 22,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              } else if (value == 'password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              } else if (value == 'logout') {
                SessionService.logout().then((_) {
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
