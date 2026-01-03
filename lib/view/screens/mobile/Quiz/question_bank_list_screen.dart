
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../viewmodel/Quiz/mock_test_list_controller.dart';
import '../../../../data/model/quiz_model.dart'; 

class QuestionBankListScreen extends StatelessWidget {
  QuestionBankListScreen({super.key});

  final MockTestListController controller = Get.put(MockTestListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Question Bank'),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
             indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'English'),
              Tab(text: 'বাংলা'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
             // If controller wasn't already loaded (unlikely if navigating from Home where we might pre-load, but safe execution)
             controller.loadAllData();
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          
          return TabBarView(
            children: [
              _buildSetList(context, 'English'),
              _buildSetList(context, 'Bengali'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSetList(BuildContext context, String language) {
    List<List<Questions>> sets = controller.getSets(language);
    
    if (sets.isEmpty) {
      return Center(child: Text("No questions available for $language"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sets.length,
      separatorBuilder: (ctx, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildTestCard(context, language, index, sets[index]);
      },
    );
  }

  Widget _buildTestCard(BuildContext context, String language, int index, List<Questions> questions) {
    return InkWell(
      onTap: () {
        Get.toNamed('/question-bank-view', arguments: {'questions': questions, 'title': '${language} Set ${index + 1}'});
      },
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.menu_book, color: Colors.purple, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    '${language == "English" ? "History Chapter" : "ইতিহাস অধ্যায়"} ${index + 1}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${questions.length} Questions',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
