import 'package:get/get.dart';
import 'package:study_test_app/view/screens/mobile/Auth/forgot_password_screen.dart';
import 'package:study_test_app/view/screens/mobile/Auth/reset_password_screen.dart';
import 'package:study_test_app/view/screens/mobile/Home/HomeScreen.dart';
import 'package:study_test_app/view/screens/mobile/Info/PrivacyPolicyScreen.dart';
import 'package:study_test_app/view/screens/mobile/Info/TermsAndConditionsScreen.dart';
import 'package:study_test_app/view/screens/mobile/Info/AboutUsScreen.dart';
import '../../view/screens/mobile/Quiz/quiz_screen.dart';
import '../../view/screens/mobile/Quiz/mock_test_list_screen.dart';
import '../../view/screens/mobile/Quiz/question_bank_list_screen.dart';
import '../../view/screens/mobile/Quiz/question_bank_view_screen.dart';
import '../../view/screens/mobile/Quiz/live_test_list_screen.dart';

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
    GetPage(name: '/quiz', page: () => QuizScreen()),
    GetPage(name: '/mock-test-list', page: () => MockTestListScreen()),
    GetPage(name: '/question-bank-list', page: () => QuestionBankListScreen()),
    GetPage(name: '/question-bank-view', page: () => const QuestionBankViewScreen()),
    GetPage(name: '/live-test-list', page: () => const LiveTestListScreen()),
    
    // Static Pages
    GetPage(name: '/privacy-policy', page: () => const PrivacyPolicyScreen()),
    GetPage(name: '/terms-conditions', page: () => const TermsAndConditionsScreen()),
    GetPage(name: '/about-us', page: () => const AboutUsScreen()),
  ];
}
