import 'package:get/get.dart';
import 'package:myapp/app/models/behavior_model.dart';
import 'package:myapp/app/models/child_model.dart';
import 'package:myapp/app/services/auth_service.dart';
import 'package:myapp/app/services/child_service.dart';
import 'package:myapp/app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDashboardController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ChildService _childService = ChildService();

  final Rx<Child?> child = Rx<Child?>(null);
  final RxList<Behavior> behaviors = RxList<Behavior>();

  @override
  void onReady() {
    super.onReady();
    _getChildAndBehaviors();
  }

  Future<void> _getChildAndBehaviors() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final userDoc = await _userService.getUser(user.uid);
      final childId = userDoc['childId'];
      if (childId != null) {
        child.value = await _childService.getChild(childId);
        if (child.value != null) {
          _getBehaviors(child.value!.id);
        }
      }
    }
  }

  void _getBehaviors(String childId) {
    FirebaseFirestore.instance
        .collection('children')
        .doc(childId)
        .collection('behaviors')
        .snapshots()
        .listen((snapshot) {
      behaviors.value = snapshot.docs
          .map((doc) => Behavior(
                id: doc.id,
                name: doc['name'],
                description: doc['description'],
              ))
          .toList();
    });
  }
}
