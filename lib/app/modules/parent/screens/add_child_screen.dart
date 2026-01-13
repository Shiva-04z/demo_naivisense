import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/services/auth_service.dart';
import 'package:myapp/app/services/child_service.dart';

class AddChildScreen extends StatelessWidget {
  final ChildService _childService = ChildService();
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Child'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _childService.createChild(
                    _authService.getCurrentUser()!.uid,
                    _nameController.text,
                    int.parse(_ageController.text),
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Add Child'),
            ),
          ],
        ),
      ),
    );
  }
}
