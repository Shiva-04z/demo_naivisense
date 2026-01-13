import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/tasks_page/task_page_controller.dart';

class TasksPageView extends GetView<TaskPageController> {
  const TasksPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final tealTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
    );

    return Theme(
      data: tealTheme,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Iconsax.arrow_left_2,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          title: const Text(
          'Tasks',
          style: TextStyle(
        fontSize: 28,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.teal.shade900,
      elevation: 0,

    ),
    body: Column(
    children: [
    // Custom Tab Bar
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
    child: Container(
    height: 56,
    decoration: BoxDecoration(
    color: Colors.grey[50],
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
    children: [
    Expanded(
    child: Obx(() => _buildTabButton(
    'Assigned to Me',
    0,
    controller.selectedTabIndex.value == 0,
    )),
    ),
    Expanded(
    child: Obx(() => _buildTabButton(
    'Assigned by Me',
    1,
    controller.selectedTabIndex.value == 1,
    )),
    ),
    ],
    ),
    ),
    ),

    // Task Count
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Obx(() => Text(
    '${controller.selectedTabIndex.value == 0 ? controller.tasksAssignedToMe.length : controller.tasksAssignedByMe.length} tasks',
    style: const TextStyle(
    fontSize: 14,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    ),
    )),
    TextButton.icon(
    onPressed: () {},
    icon: Icon(
    Icons.filter_list,
    color: Colors.teal[700],
    size: 18,
    ),
    label: Text(
    'Filter',
    style: TextStyle(
    color: Colors.teal[700],
    fontWeight: FontWeight.w600,
    ),
    ),
    ),
    ],
    ),
    ),

    const SizedBox(height: 8),

    // Task List
    Expanded(
    child: Obx(() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    itemCount: controller.selectedTabIndex.value == 0
    ? controller.tasksAssignedToMe.length
        : controller.tasksAssignedByMe.length,
    itemBuilder: (context, index) {
    final task = controller.selectedTabIndex.value == 0
    ? controller.tasksAssignedToMe[index]
        : controller.tasksAssignedByMe[index];
    return _buildTaskCard(task);
    },
    )),
    ),
    ],
    ),
    floatingActionButton: FloatingActionButton.extended(
    onPressed: controller.createNewTask,
    backgroundColor: Colors.teal[600],
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
    ),
    icon: const Icon(Icons.add, size: 24),
    label: const Text(
    'New Task',
    style: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    ),
    ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ),
    );
    }

  Widget _buildTabButton(String text, int index, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[600] : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => controller.switchTab(index),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => controller.toggleTaskStatus(task.id),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: task.priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: task.priorityColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      task.priority
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: task.priorityColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                task.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigner',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.teal[100],
                            child: Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.teal[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.assigner,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assignee',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.orange[100],
                            child: Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.orange[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.assignee,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: task.formattedDueDate == 'Overdue'
                              ? Colors.red[50]
                              : Colors.teal[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: task.formattedDueDate == 'Overdue'
                                  ? Colors.red[700]
                                  : Colors.teal[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.formattedDueDate,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: task.formattedDueDate == 'Overdue'
                                    ? Colors.red[700]
                                    : Colors.teal[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Status indicator
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: task.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.status
                        .toString()
                        .split('.')
                        .last,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: task.statusColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    task.statusIcon,
                    color: task.statusColor,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}