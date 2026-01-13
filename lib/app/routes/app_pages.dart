import 'package:get/get.dart';
import 'package:myapp/app/modules/auth/screens/login_screen.dart';
import 'package:myapp/app/modules/auth/screens/register_screen.dart';
import 'package:myapp/app/modules/auth/screens/splash_screen.dart';
import 'package:myapp/app/modules/parent/screens/parent_dashboard_screen.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.PARENT_DASHBOARD,
      page: () => ParentDashboardScreen(),
    ),
  ];
}
