// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/global_screen_size.dart';
import '../components/AppBer/my_drawer.dart';
import 'widgets/test_card.dart';
import 'widgets/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StudyApp'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: AppColors.background,
        child: ListView(
          children: [
            _buildHero(context),
            const SizedBox(height: 20),
            _buildBody(context),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            _testListView(context),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    String currentSize = getCurrentScreen(screenSize: Get.width);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: currentSize == 'xsmall'
            ? Get.height * 0.3
            : currentSize == 'small'
            ? Get.height * 0.4
            : currentSize == 'medium'
            ? Get.height * 0.5
            : Get.height * 0.5,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Image.asset('assets/images/hero.png', fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 10,
      runSpacing: 20,
      direction: Axis.horizontal,
      children: [
        serviceCard('Mock Tests', Colors.orange, Icons.quiz),
        serviceCard('Question Bank', Colors.purple, Icons.book),
        serviceCard('Live Test', Colors.pink, Icons.today),
        serviceCard('Study Plan', Colors.teal, Icons.school),
      ],
    );
  }

  Widget _testListView(BuildContext context) {
    List<Map> data = [
      {
        'title': 'Physics Test 1',
        'subtitle': 'Completed on 12th Aug',
        'percentage': 85,
      },
      {
        'title': 'Chemistry Test 2',
        'subtitle': 'Completed on 15th Aug',
        'percentage': 90,
      },
      {
        'title': 'Maths Test 3',
        'subtitle': 'Completed on 18th Aug',
        'percentage': 80,
      },
    ];

    // Example data for the test cards
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.indigo,
      Colors.yellow,
      Colors.purple,
    ];
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => TestCard(
        title: 'Physics Test ${index + 1}',
        subtitle:
            'Completed on ${DateTime.now().subtract(Duration(days: index)).toLocal().toString().split(' ')[0]}',
        percentage: 85 + (index * 5),
        iconColor: colors[index % colors.length],
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
