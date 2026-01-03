
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../viewmodel/Quiz/quiz_controller.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../data/model/quiz_model.dart'; // Import Questions model

class QuizScreen extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

  QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('History Quiz'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.isQuizFinished.value) {
          return _buildResultScreen();
        }

        if (controller.questions.isEmpty) {
           return Center(child: Text("No questions available"));
        }

        return _buildQuizBody(context);
      }),
    );
  }

  Widget _buildQuizBody(BuildContext context) {
    Questions currentQuestion =
        controller.questions[controller.currentQuestionIndex.value];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 24),
          _buildQuestionCard(context, currentQuestion),
          const SizedBox(height: 24),
          Expanded(child: _buildOptionsList(currentQuestion)),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Button
        Obx(() => controller.currentQuestionIndex.value > 0
            ? ElevatedButton(
                onPressed: controller.previousQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Previous", style: TextStyle(color: Colors.white)),
              )
            : const SizedBox.shrink()),

        // Next/Finish Button
        Obx(() {
          bool isLast = controller.currentQuestionIndex.value ==
              controller.questions.length - 1;
          return ElevatedButton(
            onPressed: controller.nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              isLast ? "Finish" : "Next",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Question ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   "Score: ${controller.score.value}",
            //   style: TextStyle(
            //     color: AppColors.primary,
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (controller.currentQuestionIndex.value + 1) /
              controller.questions.length,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, Questions question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question.question ?? "",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsList(Questions question) {
    if (question.options == null) return Container();
    
    // Convert options object to map for easier iteration
    Map<String, String?> optionsMap = {
      "A": question.options!.a,
      "B": question.options!.b,
      "C": question.options!.c,
      "D": question.options!.d,
    };

    return ListView.separated(
      itemCount: optionsMap.length,
      separatorBuilder: (ctx, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        String key = optionsMap.keys.elementAt(index);
        String? value = optionsMap[key];
        
        if (value == null) return SizedBox.shrink();

        return Obx(() {
          bool isSelected = controller
                  .userAnswers[controller.currentQuestionIndex.value] ==
              key;
          
          return InkWell(
            onTap: () => controller.selectAnswer(key),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                   Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          key,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.check_circle_outline, size: 100, color: AppColors.success),
            // Image.asset('assets/images/trophy.png', height: 150), // Verify if asset exists first
            const SizedBox(height: 24),
            Text(
              "Quiz Completed!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Your Score: ${controller.score.value} / ${controller.questions.length}",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
             const SizedBox(height: 16),
             TextButton(
              onPressed: () => controller.restartQuiz(),
              child: Text("Restart Quiz", style: TextStyle(color: AppColors.primary, fontSize: 16)),
             )
          ],
        ),
      ),
    );
  }
}
