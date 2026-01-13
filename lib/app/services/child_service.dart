import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/models/child_model.dart';

class ChildService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChild(String parentId, String name, int age) async {
    final childDocRef = await _firestore.collection('children').add({
      'name': name,
      'age': age,
    });
    await _firestore.collection('users').doc(parentId).update({
      'childId': childDocRef.id,
    });
  }

  Future<Child?> getChild(String childId) async {
    final childDoc = await _firestore.collection('children').doc(childId).get();
    if (childDoc.exists) {
      return Child(
        id: childDoc.id,
        name: childDoc['name'],
        age: childDoc['age'],
      );
    }
    return null;
  }
}
