import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBehavior(String childId, String name, String description) async {
    await _firestore
        .collection('children')
        .doc(childId)
        .collection('behaviors')
        .add({
      'name': name,
      'description': description,
    });
  }
}
