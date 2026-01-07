import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:study_test_app/data/services/appwrite_service.dart';
import 'package:study_test_app/viewmodel/Auth/auth_controller.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppwriteService()); // Initialize Appwrite Service
  Get.put(AuthController(), permanent: true); // Initialize Global AuthController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Study Test',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}

