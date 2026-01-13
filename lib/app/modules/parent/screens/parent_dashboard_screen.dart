import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/parent/controllers/parent_dashboard_controller.dart';
import 'package:myapp/app/modules/parent/screens/add_child_screen.dart';
import 'package:myapp/app/modules/parent/screens/add_behavior_screen.dart';
import 'package:myapp/app/modules/parent/screens/add_behavior_instance_screen.dart';
import 'package:myapp/app/modules/parent/screens/behavior_history_screen.dart';
import 'package:myapp/app/modules/parent/screens/generate_report_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ParentDashboardController controller = Get.put(ParentDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard'),
      ),
      body: Obx(() {
        if (controller.child.value != null) {
          return Column(
            children: [
              Text('Child Name: ${controller.child.value!.name}'),
              Text('Child Age: ${controller.child.value!.age}'),
              Expanded(
                child: Obx(() {
                  if (controller.behaviors.isNotEmpty) {
                    return ListView.builder(
                      itemCount: controller.behaviors.length,
                      itemBuilder: (context, index) {
                        final behavior = controller.behaviors[index];
                        return ListTile(
                          title: Text(behavior.name),
                          subtitle: Text(behavior.description),
                          onTap: () => Get.to(() => AddBehaviorInstanceScreen(
                                childId: controller.child.value!.id,
                                behaviorId: behavior.id,
                              )),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.history),
                                onPressed: () => Get.to(() => BehaviorHistoryScreen(
                                      childId: controller.child.value!.id,
                                      behaviorId: behavior.id,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.bar_chart),
                                onPressed: () => Get.to(() => GenerateReportScreen(
                                      childId: controller.child.value!.id,
                                      behaviorId: behavior.id,
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No behaviors added yet.'),
                    );
                  }
                }),
              ),
            ],
          );
        } else {
          return Center(
            child: ElevatedButton(
              onPressed: () => Get.to(() => AddChildScreen()),
              child: Text('Add Child'),
            ),
          );
        }
      }),
      floatingActionButton: Obx(() {
        if (controller.child.value != null) {
          return FloatingActionButton(
            onPressed: () => Get.to(() => AddBehaviorScreen(childId: controller.child.value!.id)),
            child: Icon(Icons.add),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
