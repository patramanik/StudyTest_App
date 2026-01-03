
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../data/model/quiz_model.dart';

class MockTestListController extends GetxController {
  final RxMap<String, List<List<Questions>>> partitionedQuestions =
      <String, List<List<Questions>>>{}.obs; // 'English' -> [[20 qs], [20 qs]]
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      
      // Load Bengali Data
      await _loadAndPartition('Bengali', 'lib/data/data/history_bengoli.json');
      
      // Load English Data
      await _loadAndPartition('English', 'lib/data/data/history_english.json');

    } catch (e) {
      Get.snackbar("Error", "Failed to load test list");
      print("Error loading mock tests: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAndPartition(String key, String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      final data = json.decode(response);
      QuizModel quizData = QuizModel.fromJson(data);

      if (quizData.questions != null && quizData.questions!.isNotEmpty) {
        List<Questions> allQuestions = quizData.questions!;
        List<List<Questions>> chunks = [];
        
        for (int i = 0; i < allQuestions.length; i += 20) {
          int end = (i + 20 < allQuestions.length) ? i + 20 : allQuestions.length;
          chunks.add(allQuestions.sublist(i, end));
        }
        partitionedQuestions[key] = chunks;
      }
    } catch (e) {
      print("Failed to load/parse $path: $e");
    }
  }

  List<List<Questions>> getSets(String language) {
    return partitionedQuestions[language] ?? [];
  }
}
