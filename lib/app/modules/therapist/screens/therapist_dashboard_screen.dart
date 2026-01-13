import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/therapist/controllers/therapist_dashboard_controller.dart';
import 'package:myapp/app/modules/therapist/screens/case_load_screen.dart';

class TherapistDashboardScreen extends StatelessWidget {
  final TherapistDashboardController controller =
      Get.put(TherapistDashboardController());

  final List<Widget> screens = [
    CaseLoadScreen(),
    Scaffold(body: Center(child: Text('Schedule'))),
    Scaffold(body: Center(child: Text('Library'))),
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
              icon: Icon(Icons.people),
              label: 'Case Load',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}
