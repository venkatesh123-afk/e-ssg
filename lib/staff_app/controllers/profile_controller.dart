// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../api/api_collection.dart';
// import '../api/api_service.dart';
// import '../model/profile_model.dart';
// import '../utils/get_storage.dart';

// class ProfileController extends GetxController {
//   final isLoading = true.obs;
//   final profile = Rxn<ProfileModel>();
//   int? _currentUserId; // Track current user ID

//   @override
//   void onInit() {
//     super.onInit();
//     // Get current user ID from storage
//     _currentUserId = AppStorage.getUserId();

//     // 🔥 LOAD CACHED PROFILE IMMEDIATELY (UX IMPROVEMENT)
//     _loadFromCache();

//     fetchProfile();
//   }

//   void _loadFromCache() {
//     final savedUsers = AppStorage.getSavedUsers();
//     if (_currentUserId != null && savedUsers.isNotEmpty) {
//       final user = savedUsers.firstWhere(
//         (u) => u['userid'] == _currentUserId,
//         orElse: () => {},
//       );

//       if (user.isNotEmpty) {
//         // Create a temporary profile model from cache
//         profile.value = ProfileModel(
//           name: user['name'] ?? '',
//           avatar: user['avatar'] ?? '',
//           email: user['email'] ?? '',
//           userLogin: user['user_login'] ?? '',
//           // Fill other required fields with defaults
//           father: '',
//           gender: '',
//           dob: '',
//           doj: '',
//           jobType: '',
//           shift: '',
//           designation: user['role'] ?? '',
//           department: '',
//           mobile: user['mobile'] ?? '',
//           nationality: '',
//           marital: '',
//           religion: '',
//           community: '',
//           cAddress: '',
//           pAddress: '',
//           pan: '',
//           aadhar: '',
//           bankAcc: '',
//           bank: '',
//           ifsc: '',
//           roleId: 0,
//           status: 1,
//         );
//         // Note: We keep isLoading true while fresh data is being fetched
//       }
//     }
//   }

//   Future<void> fetchProfile() async {
//     try {
//       isLoading.value = true;

//       // 🔍 CHECK IF USER CHANGED (MULTI-USER SUPPORT)
//       final storedUserId = AppStorage.getUserId();
//       if (_currentUserId != null && storedUserId != _currentUserId) {
//         // User changed - clear old profile data
//         profile.value = null;
//         _currentUserId = storedUserId;
//         _loadFromCache(); // Try loading new user's cache
//       } else if (_currentUserId == null && storedUserId != null) {
//         // First time loading or user ID was set
//         _currentUserId = storedUserId;
//         _loadFromCache();
//       }

//       final response = await ApiService.getRequest(ApiCollection.myProfile);

//       // API returns profile data directly (no success wrapper)
//       // Check if response has success field for backward compatibility
//       if (response.containsKey('success')) {
//         final success =
//             response['success'] == true || response['success'] == "true";
//         if (!success) {
//           if (profile.value == null) {
//             Get.snackbar("Error", "Profile fetch failed");
//           }
//           return;
//         }
//         // If success field exists, data might be in 'data' field or response itself
//         final profileData = response['data'] ?? response;
//         profile.value = ProfileModel.fromJson(profileData);
//       } else {
//         // No success field - response is the profile data directly
//         profile.value = ProfileModel.fromJson(response);
//       }

//       // 🔥 UPDATE SESSION WITH PROFILE DETAILS
//       if (profile.value != null && _currentUserId != null) {
//         final p = profile.value!;
//         final token = AppStorage.getToken();
//         if (token != null) {
//           final loginType = AppStorage.getLoginType();
//           final role = AppStorage.getUserRole();
//           final permissions = AppStorage.getPermissions();

//           AppStorage.saveUserSession({
//             'user_login': p.userLogin.isNotEmpty
//                 ? p.userLogin
//                 : _currentUserId.toString(),
//             'userid': _currentUserId,
//             'name': p.name,
//             'avatar': p.avatar,
//             'email': p.email,
//             'mobile': p.mobile,
//             'login_type': loginType,
//             'role': role,
//             'permissions': permissions,
//           }, token);
//         }
//       }
//     } catch (e) {
//       debugPrint("PROFILE FETCH ERROR: $e");
//       // Don't show snackbar if we already have cached data
//       if (profile.value == null) {
//         Get.snackbar("Error", "Profile fetch failed: ${e.toString()}");
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔄 REFRESH PROFILE (CALL THIS WHEN USER CHANGES)
//   void refreshProfile() {
//     _currentUserId = AppStorage.getUserId();
//     profile.value = null;
//     _loadFromCache();
//     fetchProfile();
//   }

//   @override
//   void onClose() {
//     profile.value = null; // 🔥 clear user data
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';
import '../model/profile_model.dart';
import '../utils/get_storage.dart';

class ProfileController extends GetxController {
  final isLoading = true.obs;
  final profile = Rxn<ProfileModel>();
  int? _currentUserId; // Track current user ID

  // ================= BOTTOM NAV =================
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Get current user ID from storage
    _currentUserId = AppStorage.getUserId();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      // 🔍 CHECK IF USER CHANGED (MULTI-USER SUPPORT)
      final storedUserId = AppStorage.getUserId();
      if (_currentUserId != null && storedUserId != _currentUserId) {
        // User changed - clear old profile data
        profile.value = null;
        _currentUserId = storedUserId;
      } else if (_currentUserId == null && storedUserId != null) {
        // First time loading or user ID was set
        _currentUserId = storedUserId;
      }

      final response = await ApiService.getRequest(ApiCollection.myProfile);

      // API returns profile data directly (no success wrapper)
      // Check if response has success field for backward compatibility
      if (response.containsKey('success')) {
        final success =
            response['success'] == true || response['success'] == "true";
        if (!success) {
          Get.snackbar("Error", "Profile fetch failed");
          return;
        }
        // If success field exists, data might be in 'data' field or response itself
        final profileData = response['data'] ?? response;
        profile.value = ProfileModel.fromJson(profileData);
      } else {
        // No success field - response is the profile data directly
        profile.value = ProfileModel.fromJson(response);
      }

      // 🔥 UPDATE SESSION WITH PROFILE DETAILS
      if (profile.value != null && _currentUserId != null) {
        final p = profile.value!;
        final token = AppStorage.getToken();
        if (token != null) {
          final loginType = AppStorage.getLoginType();
          final role = AppStorage.getUserRole();
          final permissions = AppStorage.getPermissions();

          AppStorage.saveUserSession({
            'user_login': p.userLogin.isNotEmpty
                ? p.userLogin
                : _currentUserId.toString(),
            'userid': _currentUserId,
            'name': p.name,
            'avatar': p.avatar,
            'email': p.email,
            'mobile': p.mobile,
            'login_type': loginType,
            'role': role,
            'permissions': permissions,
          }, token);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Profile fetch failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔄 REFRESH PROFILE (CALL THIS WHEN USER CHANGES)
  void refreshProfile() {
    _currentUserId = AppStorage.getUserId();
    profile.value = null;
    fetchProfile();
  }

  @override
  void onClose() {
    profile.value = null; // 🔥 clear user data
    super.onClose();
  }
}
