import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';

class LiveTestListScreen extends StatelessWidget {
  const LiveTestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Live Tests'),
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
        body: TabBarView(
          children: [
            _buildTestList(context, 'English'),
            _buildTestList(context, 'Bengali'),
          ],
        ),
      ),
    );
  }

  Widget _buildTestList(BuildContext context, String language) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      separatorBuilder: (ctx, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildTestCard(context, index, language);
      },
    );
  }

  Widget _buildTestCard(BuildContext context, int index, String language) {
    return InkWell(
      onTap: () {
        Get.toNamed('/quiz', arguments: {'mode': 'live', 'language': language});
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
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.timer, color: Colors.pink, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${language == 'English' ? 'Live Test Set' : 'লাইভ টেস্ট সেট'} ${index + 1}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '25 Questions • Random',
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
