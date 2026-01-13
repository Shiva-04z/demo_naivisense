import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import 'package:myapp/app/services/auth_service.dart';
import 'package:myapp/app/services/user_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  void onReady() {
    super.onReady();
    _checkUser();
  }

  void _checkUser() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final userDoc = await _userService.getUser(user.uid);
      final role = userDoc['role'];
      if (role == 'Parent') {
        Get.offAllNamed(Routes.PARENT_DASHBOARD);
      } else if (role == 'Therapist') {
        Get.offAllNamed(Routes.THERAPIST_DASHBOARD);
      } else if (role == 'Admin') {
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
