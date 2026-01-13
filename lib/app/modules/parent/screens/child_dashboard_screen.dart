import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/models/behavior_model.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ChildDashboardScreen extends StatelessWidget {
  final String childId;

  ChildDashboardScreen({required this.childId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Child Dashboard'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('children')
            .doc(childId)
            .collection('behaviors')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final behaviors = snapshot.data!.docs
              .map((doc) => Behavior(
                    id: doc.id,
                    name: doc['name'],
                    description: doc['description'],
                  ))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: behaviors.length,
            itemBuilder: (context, index) {
              final behavior = behaviors[index];
              return _buildBehaviorCard(context, behavior);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_BEHAVIOR, parameters: {'childId': childId}),
        child: Icon(Icons.add),
        tooltip: 'Add Behavior',
      ),
    );
  }

  Widget _buildBehaviorCard(BuildContext context, Behavior behavior) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.BEHAVIOR_DETAILS, parameters: {'childId': childId, 'behaviorId': behavior.id}),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(behavior.name, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(behavior.description, style: Theme.of(context).textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
