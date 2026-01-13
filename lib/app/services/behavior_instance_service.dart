import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviorInstanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBehaviorInstance(
      String childId, String behaviorId, String comment) async {
    await _firestore
        .collection('children')
        .doc(childId)
        .collection('behaviors')
        .doc(behaviorId)
        .collection('behavior_instances')
        .add({
      'timestamp': Timestamp.now(),
      'comment': comment,
    });
  }
}
