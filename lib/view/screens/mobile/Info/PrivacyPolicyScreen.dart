import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          '''
Privacy Policy


1. Introduction
Welcome to StudyTest. We respect your privacy and are committed to protecting your personal data.

2. Data We Collect
We may collect personal information such as your name, email address, and usage data when you use our application.

3. How We Use Your Data
We use your data to provide and improve our services, manage your account, and communicate with you.

4. Data Security
We implement appropriate security measures to protect your personal information.

5. Contact Us
If you have any questions about this Privacy Policy, please contact us.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
