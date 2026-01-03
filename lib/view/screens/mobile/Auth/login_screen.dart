import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../viewmodel/Auth/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Header
              _buildHeader(context),
              const SizedBox(height: 50),
              // Login Form
              _buildLoginForm(context),
              const SizedBox(height: 24),
              // Social Login
              _buildSignUpPrompt(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sing In',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Login to your account',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.primary,
                  ),
                  onPressed: () => controller.obscurePassword.toggle(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.toNamed('/forgot-password'),
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),

              ],
            ),
            child: TextButton(
              onPressed: _submitForm,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondaryLight,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  
                ),
              ),
              child: const Text("Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
                
              ),
            ),
          ),

        
        ],
      ),
    );
  }

  // Widget _buildSocialLogin(BuildContext context) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           const Expanded(child: Divider(color: AppColors.border)),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             child: Text(
  //               'OR',
  //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 color: AppColors.textSecondary,
  //               ),
  //             ),
  //           ),
  //           const Expanded(child: Divider(color: AppColors.border)),
  //         ],
  //       ),
  //       const SizedBox(height: 24),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           IconButton(
  //             icon: Icon(Icons.facebook, size: 40, color: AppColors.facebook),
  //             onPressed: () {},
  //           ),
  //           const SizedBox(width: 24),
  //           IconButton(
  //             icon: Icon(Icons.golf_course, size: 40, color: AppColors.google),
  //             onPressed: () {},
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text("|", style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => controller.loginAsGuest(),
          child: Text(
            'Guest',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() {
          if (controller.canCheckBiometrics.value) {
            return Row(
              children: [
                const SizedBox(width: 10),
                Text("|", style: TextStyle(color: AppColors.textSecondary)),
                IconButton(
                  icon: Icon(Icons.fingerprint, color: AppColors.primary),
                  onPressed: () => controller.authenticate(),
                  tooltip: "Login with Biometrics",
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.login();
    }
  }
}
