// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../components/AppBer/my_drawer.dart';

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
        child: Center(
          child: Text(
            'Welcome to StudyApp',
            style: TextStyle(
              color: AppColors.background,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
