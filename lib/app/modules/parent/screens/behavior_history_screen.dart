import 'package:flutter/material.dart';

import 'package:myapp/app/models/behavior_instance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviorHistoryScreen extends StatelessWidget {
  final String childId;
  final String behaviorId;

  BehaviorHistoryScreen({required this.childId, required this.behaviorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Behavior History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('children')
            .doc(childId)
            .collection('behaviors')
            .doc(behaviorId)
            .collection('behavior_instances')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final instances = snapshot.data!.docs
                .map((doc) => BehaviorInstance(
                      id: doc.id,
                      timestamp: (doc['timestamp'] as Timestamp).toDate(),
                      comment: doc['comment'],
                    ))
                .toList();
            return ListView.builder(
              itemCount: instances.length,
              itemBuilder: (context, index) {
                final instance = instances[index];
                return ListTile(
                  title: Text(instance.timestamp.toString()),
                  subtitle: Text(instance.comment),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
