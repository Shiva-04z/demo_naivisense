import 'package:get/get.dart';
import 'package:myapp/app/modules/auth/bindings/auth_binding.dart';
import 'package:myapp/app/modules/auth/screens/login_screen.dart';
import 'package:myapp/app/modules/auth/screens/register_screen.dart';
import 'package:myapp/app/modules/auth/screens/splash_screen.dart';
import 'package:myapp/app/modules/parent/screens/add_child_screen.dart';
import 'package:myapp/app/modules/parent/screens/add_behavior_screen.dart';
import 'package:myapp/app/modules/parent/screens/behavior_details_screen.dart';
import 'package:myapp/app/modules/parent/screens/child_dashboard_screen.dart';
import 'package:myapp/app/modules/parent/screens/parent_dashboard_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PARENT_DASHBOARD,
      page: () => ParentDashboardScreen(),
    ),
    GetPage(
      name: Routes.ADD_CHILD,
      page: () => AddChildScreen(),
    ),
    GetPage(
      name: Routes.CHILD_DASHBOARD,
      page: () => ChildDashboardScreen(childId: Get.parameters['childId']!),
    ),
    GetPage(
      name: Routes.ADD_BEHAVIOR,
      page: () => AddBehaviorScreen(childId: Get.parameters['childId']!),
    ),
    GetPage(
      name: Routes.BEHAVIOR_DETAILS,
      page: () => BehaviorDetailsScreen(
        childId: Get.parameters['childId']!,
        behaviorId: Get.parameters['behaviorId']!,
      ),
    ),
  ];
}
