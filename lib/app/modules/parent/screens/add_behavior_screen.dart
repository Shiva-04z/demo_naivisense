import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AddBehaviorScreen extends StatelessWidget {
  final String childId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddBehaviorScreen({required this.childId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Behavior'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.auto_mode),
            onPressed: () => themeProvider.setSystemTheme(),
            tooltip: 'Set System Theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              context,
              controller: _nameController,
              labelText: 'Name',
              icon: Icons.edit,
            ),
            SizedBox(height: 20),
            _buildTextField(
              context,
              controller: _descriptionController,
              labelText: 'Description',
              icon: Icons.description,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final description = _descriptionController.text;
                if (name.isNotEmpty && description.isNotEmpty) {
                  await _firestore
                      .collection('children')
                      .doc(childId)
                      .collection('behaviors')
                      .add({
                    'name': name,
                    'description': description,
                  });
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Please enter valid data');
                }
              },
              child: Text('Add Behavior'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
