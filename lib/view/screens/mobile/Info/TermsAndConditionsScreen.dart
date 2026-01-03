import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          '''
Terms and Conditions


1. Acceptance of Terms
By accessing or using StudyTest, you agree to be bound by these Terms and Conditions.

2. Use of License
Permission is granted to temporarily download one copy of the materials (information or software) on StudyTest for personal, non-commercial transitory viewing only.

3. Disclaimer
The materials on StudyTest are provided on an 'as is' basis. We make no warranties, expressed or implied.

4. Limitations
In no event shall StudyTest or its suppliers be liable for any damages arising out of the use or inability to use the materials on StudyTest.

5. Governing Law
These terms and conditions are governed by and construed in accordance with the laws of [Your Country] and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
