import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import 'package:myapp/app/services/auth_service.dart';
import 'package:myapp/app/services/user_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = await _authService.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                  final userDoc = await _userService.getUser(credential.user!.uid);
                  final role = userDoc['role'];
                  if (role == 'Parent') {
                    Get.offAllNamed(Routes.PARENT_DASHBOARD);
                  } else if (role == 'Therapist') {
                    Get.offAllNamed(Routes.THERAPIST_DASHBOARD);
                  } else if (role == 'Admin') {
                    Get.offAllNamed(Routes.ADMIN_DASHBOARD);
                  }
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.REGISTER),
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
