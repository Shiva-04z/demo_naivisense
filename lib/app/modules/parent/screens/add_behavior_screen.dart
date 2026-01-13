import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/services/behavior_service.dart';

class AddBehaviorScreen extends StatelessWidget {
  final String childId;
  final BehaviorService _behaviorService = BehaviorService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AddBehaviorScreen({required this.childId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Behavior'),
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
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _behaviorService.createBehavior(
                    childId,
                    _nameController.text,
                    _descriptionController.text,
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Add Behavior'),
            ),
          ],
        ),
      ),
    );
  }
}
