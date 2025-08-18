import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../viewmodel/Auth/auth_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text("OTP Verification", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Enter the 6-digit OTP sent to your email", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.otpController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        prefixIcon: Icon(Icons.verified, color: AppColors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) {
                        if (value == null || value.length != 6) {
                          return 'Enter 6-digit OTP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.verifyOtp(); // logic to verify OTP
                          Get.toNamed('/reset-password');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("Verify OTP",
                        style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
