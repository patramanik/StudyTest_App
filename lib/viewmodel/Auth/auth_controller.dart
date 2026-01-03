// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool canCheckBiometrics = false.obs;

  final LocalAuthentication auth = LocalAuthentication();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkBiometrics();
    checkLoginStatus();
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
          biometricOnly: false, // Allows PIN/Pattern backup if biometrics fail
        ),
      );

      if (authenticated) {
        // Log in the user if biometrics pass
        // In a real app, you might want to re-verify or link this to a specific user
        // For now, we reuse the stored user or guest
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('current_user_name')) {
             await prefs.setBool('isLoggedIn', true);
             Get.snackbar("Success", "Authenticated via Biometrics");
             Get.offAllNamed('/home');
        } else {
             Get.snackbar("Notice", "Please login manually first to enable biometrics for future.");
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
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == true) {
      Get.offAllNamed('/home');
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
      final prefs = await SharedPreferences.getInstance();
      
      String? storedEmail = prefs.getString('user_email');
      String? storedPassword = prefs.getString('user_password');
      String? storedName = prefs.getString('user_name');

      if (storedEmail == email && storedPassword == password) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('current_user_name', storedName ?? "User");
        
        Get.snackbar("Success", "Login successful");
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", "Invalid credentials (Try registering first)");
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAsGuest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('current_user_name', "Guest");
      
      Get.offAllNamed('/home');
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
      final prefs = await SharedPreferences.getInstance();
      
      // Store user credentials
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      
      // Auto login
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('current_user_name', name);

      Get.snackbar("Success", "Account created successfully");
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // await prefs.remove('current_user_name'); // Keep name for welcome back?
    Get.offAllNamed('/login'); // Assuming '/' is splash or login, but explicit login route is safer
  }

  void sendPasswordReset() {
    final email = emailController.text.trim();
    Get.snackbar(
      "Reset Link Sent",
      "Check your email: $email",
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/otp');
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
