import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:myapp/app/modules/admin/screens/analytics_screen.dart';
import 'package:myapp/app/modules/admin/screens/user_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final AdminDashboardController controller = Get.put(AdminDashboardController());

  final List<Widget> screens = [
    UserManagementScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}
