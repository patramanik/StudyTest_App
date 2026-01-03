
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../data/model/quiz_model.dart';
import '../../../../viewmodel/Quiz/question_bank_view_controller.dart';

class QuestionBankViewScreen extends StatelessWidget {
  const QuestionBankViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionBankViewController());
    final args = Get.arguments as Map<String, dynamic>;
    final List<Questions> questions = args['questions'];
    final String title = args['title'];

    // Clear previous state when entering screen
    controller.selectedOptions.clear();
    controller.isRevealed.clear();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        separatorBuilder: (ctx, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildQuestionCard(context, index, questions[index], controller);
        },
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, int index, Questions question, QuestionBankViewController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Q${index + 1}.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question.question ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildOption(question, "A", question.options?.a, index, controller),
          _buildOption(question, "B", question.options?.b, index, controller),
          _buildOption(question, "C", question.options?.c, index, controller),
          _buildOption(question, "D", question.options?.d, index, controller),
          
          Obx(() {
            if (controller.isAnswered(index)) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(
                          "Correct Answer: ${question.correctAnswer}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink(); // Hide answer until tapped
            }
          })
        ],
      ),
    );
  }

  Widget _buildOption(Questions question, String key, String? text, int index, QuestionBankViewController controller) {
    if (text == null) return const SizedBox.shrink();
    
    return Obx(() {
      bool isRevealed = controller.isAnswered(index);
      bool isSelected = controller.getSelectedOption(index) == key;
      bool isCorrect = question.correctAnswer == key;
      
      Color borderColor = AppColors.border;
      Color backgroundColor = Colors.transparent;
      Color textColor = AppColors.textSecondary;

      if (isRevealed) {
        if (isCorrect) {
          borderColor = AppColors.success;
          backgroundColor = AppColors.success.withOpacity(0.1);
          textColor = AppColors.success;
        } else if (isSelected) {
          borderColor = AppColors.error;
          backgroundColor = AppColors.error.withOpacity(0.1);
          textColor = AppColors.error;
        }
      }

      return InkWell(
        onTap: () => controller.selectOption(index, key, question.correctAnswer!),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
             padding: const EdgeInsets.all(8), // Added padding for touch area
             decoration: BoxDecoration(
               color: backgroundColor,
               borderRadius: BorderRadius.circular(8),
               border: Border.all(color: borderColor),
             ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isRevealed && isCorrect) || (isRevealed && isSelected) ? borderColor : Colors.transparent,
                    border: Border.all(
                      color: (isRevealed && isCorrect) || (isRevealed && isSelected) ? borderColor : AppColors.textSecondary,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 12,
                        color: (isRevealed && isCorrect) || (isRevealed && isSelected) ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: (isRevealed && isCorrect) || (isRevealed && isSelected) ? textColor : AppColors.textPrimary,
                      fontWeight: (isRevealed && isCorrect) ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
