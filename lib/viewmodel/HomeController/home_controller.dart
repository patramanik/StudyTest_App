// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  // Add your home controller logic here

  RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentActivities();
  }

  Future<void> fetchRecentActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? history = prefs.getStringList('quiz_history');
      
      if (history != null) {
        final List<Map<String, dynamic>> loadedData = history
            .map((e) => json.decode(e) as Map<String, dynamic>)
            .toList();
        recentActivities.assignAll(loadedData);
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
