// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool obscurePassword = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and Password are required",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Login",
        "Login successful",
        snackPosition: SnackPosition.BOTTOM,
      );
      // Navigate to home/dashboard
      Get.offNamed('/home');
    }
  }

  void register() {
    Get.snackbar(
      "Register",
      "Registration successful",
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/login');
  }

  void sendPasswordReset() {
    final email = emailController.text.trim();
    // Add API call or Firebase reset password logic here
    Get.snackbar(
      "Reset Link Sent",
      "Check your email: $email",
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/otp');
  }

  void sendOtp() {
    // Simulate or call API to send OTP
    print('OTP sent to ${emailController.text}');
  }

  void verifyOtp() {
    // Validate OTP here
    print('OTP verified: ${otpController.text}');
  }

  void resetPassword() {
    // Perform API call to reset password
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
