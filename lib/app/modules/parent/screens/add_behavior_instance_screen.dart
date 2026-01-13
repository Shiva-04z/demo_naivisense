import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/services/behavior_instance_service.dart';

class AddBehaviorInstanceScreen extends StatelessWidget {
  final String childId;
  final String behaviorId;
  final BehaviorInstanceService _behaviorInstanceService =
      BehaviorInstanceService();
  final TextEditingController _commentController = TextEditingController();

  AddBehaviorInstanceScreen(
      {required this.childId, required this.behaviorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Behavior'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _behaviorInstanceService.createBehaviorInstance(
                    childId,
                    behaviorId,
                    _commentController.text,
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Track Behavior'),
            ),
          ],
        ),
      ),
    );
  }
}
