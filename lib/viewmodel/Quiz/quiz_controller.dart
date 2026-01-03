
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/quiz_model.dart';
import '../HomeController/home_controller.dart';

class QuizController extends GetxController {
  final RxList<Questions> questions = <Questions>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  // Store selected answer for each question index
  final RxMap<int, String> userAnswers = <int, String>{}.obs;
  
  final RxInt score = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isQuizFinished = false.obs;


  @override
  void onInit() {
    super.onInit();
    // Get parameters passed from the list screen
    final args = Get.arguments as Map<String, dynamic>?;
    
    if (args != null && args.containsKey('questions')) {
      List<Questions> passedQuestions = args['questions'];
      questions.assignAll(passedQuestions);
      isLoading.value = false;
    } else if (args != null && args.containsKey('file')) {
      loadQuizData(args['file']);
    } else {
      // Fallback
      loadQuizData('lib/data/data/history_bengoli.json');
    }
  }

  Future<void> loadQuizData(String fileName) async {
    try {
      isLoading.value = true;
      // Load from local assets
      final String response =
          await rootBundle.loadString(fileName);
      final data = json.decode(response);
      QuizModel quizData = QuizModel.fromJson(data);

      if (quizData.questions != null) {
        questions.assignAll(quizData.questions!);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load quiz data");
      print("Error loading quiz data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(String selectedOption) {
    if (isQuizFinished.value) return;
    userAnswers[currentQuestionIndex.value] = selectedOption;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      finishQuiz();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void finishQuiz() {
    isQuizFinished.value = true;
    calculateScore();
    saveResultToHistory();
    Get.snackbar(
      "Quiz Finished",
      "You scored ${score.value} / ${questions.length}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> saveResultToHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('quiz_history') ?? [];
      
      Map<String, dynamic> result = {
        'score': score.value,
        'total': questions.length,
        'date': DateTime.now().toString(),
        'userId': prefs.getString('current_user_name') ?? 'Guest',
      };
      
      history.insert(0, json.encode(result)); // Add to beginning
      if (history.length > 10) history = history.sublist(0, 10); // Keep last 10
      
      await prefs.setStringList('quiz_history', history);
      
      // Update Home Screen
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchRecentActivities();
      }
    } catch (e) {
      print("Error saving result: $e");
    }
  }

  void calculateScore() {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswer) {
        correct++;
      }
    }
    score.value = correct;
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    isQuizFinished.value = false;
    userAnswers.clear();
  }
}
