import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../viewmodel/Auth/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthController
    // Note: Ensure AuthController is successfully put() or lazyPut() before this is built
    final AuthController authController = Get.find<AuthController>();

    return Drawer(
      child: Column(
        children: [
          // Top Section (Header)
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close drawer first
              Navigator.pushNamed(context, '/profile');
            },
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffa8edea), Color(0xfffed6e3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Profile Row
                    Obx(() {
                      final user = authController.currentUser.value;
                      final displayName = user?.name ?? 'Guest User';
                      final displayEmail = user?.email ?? '';
                      
                      return Column(
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (displayEmail.isNotEmpty)
                            Text(
                              displayEmail,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Middle Section (List Items)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Terms & Conditions"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/terms-conditions');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy Policy"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/privacy-policy');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text("About Us"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about-us');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await authController.logout();
                  },
                ),
              ],
            ),
          ),

          // Bottom Section (Version Info)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
