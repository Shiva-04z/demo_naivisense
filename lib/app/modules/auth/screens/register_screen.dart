import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/services/auth_service.dart';
import 'package:myapp/app/services/user_service.dart';

class RegisterScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxString _role = 'Parent'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
            Obx(() => DropdownButton<String>(
                  value: _role.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _role.value = newValue;
                    }
                  },
                  items: <String>['Parent', 'Therapist', 'Admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = await _authService.signUp(
                    _emailController.text,
                    _passwordController.text,
                  );
                  await _userService.createUser(
                    credential.user!.uid,
                    _emailController.text,
                    _role.value,
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
