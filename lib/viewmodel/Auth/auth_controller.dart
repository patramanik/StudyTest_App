// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:appwrite/appwrite.dart'; // Import Appwrite exceptions
import '../../data/services/appwrite_service.dart';
import 'package:appwrite/models.dart' as models;

class AuthController extends GetxController {
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool canCheckBiometrics = false.obs;
  final Rx<models.User?> currentUser = Rx<models.User?>(null);

  final LocalAuthentication auth = LocalAuthentication();
  final AppwriteService _appwriteService = Get.find<AppwriteService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkBiometrics();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await _appwriteService.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> checkBiometrics() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      canCheckBiometrics.value = canCheck && isDeviceSupported;
    } catch (e) {
      print("Error checking biometrics: $e");
    }
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        // If biometrics pass, ensure we have a valid Appwrite session or user
        final user = await _appwriteService.getCurrentUser();
        if (user != null) {
             currentUser.value = user;
             Get.snackbar("Success", "Authenticated via Biometrics");
             Get.offAllNamed('/home');
        } else {
             Get.snackbar("Notice", "Session expired. Please login manually.");
             Get.offAllNamed('/login');
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Authentication error: $e");
      print(e);
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> checkLoginStatus() async {
    try {
      final user = await _appwriteService.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        print("User is logged in: ${user.name}");
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print("Check login status error: $e");
      Get.offAllNamed('/login');
    }
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and Password are required");
      return;
    }

    try {
      isLoading.value = true;
      await _appwriteService.login(email: email, password: password);
      await loadUser(); // Refresh user data
      
      Get.snackbar("Success", "Login successful");
      Get.offAllNamed('/home');
    } on AppwriteException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAsGuest() async {
    try {
      // Guest login logic usually involves creating an anonymous session
      // For now, we'll keep the mock behavior or implement anonymous session if requested
      // _appwriteService.account.createAnonymousSession(); 
      
      Get.snackbar("Info", "Guest login not fully implemented yet");
      // Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", "Failed to login as Guest");
    }
  }

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      isLoading.value = true;
      // 1. Create Account
      await _appwriteService.signUp(email: email, password: password, name: name);
      
      // 2. Auto Login after signup
      await _appwriteService.login(email: email, password: password);
      await loadUser();

      Get.snackbar("Success", "Account created successfully");
      Get.offAllNamed('/home');
    } on AppwriteException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _appwriteService.logout();
      currentUser.value = null;
      Get.offAllNamed('/login'); // Assuming '/' is splash or login
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    }
  }

  Future<void> updateUserProfile({String? name, String? phone, String? password}) async {
    try {
      isLoading.value = true;
      final user = currentUser.value;
      
      bool isNameChanged = name != null && name.isNotEmpty && name != user?.name;
      bool isPhoneChanged = phone != null && phone.isNotEmpty && phone != user?.phone;

      if (isNameChanged) {
        await _appwriteService.updateName(name: name!);
      }

      if (isPhoneChanged) {
        if (!phone!.startsWith('+')) {
             throw "Phone number must start with '+' (e.g., +91...)";
        }
        // Appwrite updatePhone requires password confirmation
        if (password == null || password.isEmpty) {
             throw "Password required to update phone number";
        }
        await _appwriteService.updatePhone(phone: phone, password: password);
      }
      
      if (isNameChanged || isPhoneChanged) {
        await loadUser(); // Refresh data
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Info", "No changes to update");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void sendPasswordReset() {
    // Appwrite password recovery (future implementation)
    final email = emailController.text.trim();
    Get.snackbar(
      "Info",
      "Password reset functionality requires Appwrite configuration.",
      snackPosition: SnackPosition.BOTTOM,
    );
     // _appwriteService.account.createRecovery(email: email, url: 'https://example.com/reset-password');
  }

  void sendOtp() {
    print('OTP sent to ${emailController.text}');
  }

  void verifyOtp() {
    print('OTP verified: ${otpController.text}');
  }

  void resetPassword() {
    print('Password reset: ${passwordController.text}');
    Get.snackbar(
      "Password Reset",
      "Your password has been reset successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
