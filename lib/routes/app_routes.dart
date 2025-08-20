import 'package:get/get.dart';
import 'package:study_test_app/view/screens/mobile/Auth/forgot_password_screen.dart';
import 'package:study_test_app/view/screens/mobile/Auth/reset_password_screen.dart';
import 'package:study_test_app/view/screens/mobile/Home/HomeScreen.dart';

import '../view/screens/mobile/Auth/login_screen.dart';
import '../view/screens/mobile/Auth/otp_verification_screen.dart';
import '../view/screens/mobile/Auth/register_screen.dart';
import '../view/screens/mobile/SplashScreen/SplashScreen.dart';

class AppRoutes {
  static final routes = [
    // Splash Screen
    GetPage(name: '/', page: () => const SplashScreen()),

    // all Auth routes
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => SignUpScreen()),
    GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
    GetPage(name: '/otp', page: () => OtpVerificationScreen()),
    GetPage(name: '/reset-password', page: () => ResetPasswordScreen()),
    
    // Add more routes as needed
    GetPage(name: '/home', page: () => HomeScreen()),
  ];
}
