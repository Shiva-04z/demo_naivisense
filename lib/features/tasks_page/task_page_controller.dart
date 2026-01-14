import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class TaskPageController extends GetxController {
  // Tab management
  final RxInt selectedTabIndex = 0.obs;

  // Mock data for tasks assigned to me
  final RxList<Task> tasksAssignedToMe = <Task>[
    Task(
      id: '1',
      title: 'Review Mood Journal',
      description: 'Review patient’s mood entries from the past 3 days',
      assigner: 'Aarav',
      assignee: 'Me',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: Priority.high,
      status: TaskStatus.inProgress,
    ),
    Task(
      id: '2',
      title: 'Session Notes Update',
      description: 'Update therapy notes after last session',
      assigner: 'Center',
      assignee: 'Me',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: Priority.medium,
      status: TaskStatus.pending,
    ),
    Task(
      id: '3',
      title: 'Assess Anxiety Scale',
      description: 'Evaluate GAD-7 score submitted by patient',
      assigner: 'Neha Sharma',
      assignee: 'Me',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: Priority.high,
      status: TaskStatus.inProgress,
    ),
  ].obs;


  // Mock data for tasks assigned by me
  final RxList<Task> tasksAssignedByMe = <Task>[
    Task(
      id: '4',
      title: 'Breathing Exercise',
      description: 'Practice 4-7-8 breathing twice daily',
      assigner: 'Me',
      assignee: 'Aarav Mehta',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: Priority.medium,
      status: TaskStatus.inProgress,
    ),
    Task(
      id: '5',
      title: 'Gratitude Journal',
      description: 'Write 3 things you’re grateful for each night',
      assigner: 'Me',
      assignee: 'Neha Sharma',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: Priority.low,
      status: TaskStatus.completed,
    ),
    Task(
      id: '6',
      title: 'CBT Thought Record',
      description: 'Fill thought record worksheet for anxious moments',
      assigner: 'Me',
      assignee: 'Rohan Verma',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: Priority.high,
      status: TaskStatus.pending,
    ),
  ].obs;


  void switchTab(int index) {
    selectedTabIndex.value = index;
  }

  void createNewTask() {
    // Implementation for creating new task
    Get.snackbar(
      'New Task',
      'Create new task functionality would open here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleTaskStatus(String taskId) {
    // Find and toggle task status
    final allTasks = [...tasksAssignedToMe, ...tasksAssignedByMe];
    final task = allTasks.firstWhere((task) => task.id == taskId);

    if (task.status == TaskStatus.completed) {
      task.status = TaskStatus.pending;
    } else if (task.status == TaskStatus.pending) {
      task.status = TaskStatus.inProgress;
    } else {
      task.status = TaskStatus.completed;
    }

    tasksAssignedToMe.refresh();
    tasksAssignedByMe.refresh();
  }
}

// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final String assigner;
  final String assignee;
  final DateTime dueDate;
  final Priority priority;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assigner,
    required this.assignee,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  // Get due date formatted
  String get formattedDueDate {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 0) {
      return 'Overdue';
    } else {
      return 'In ${difference.inDays} days';
    }
  }

  // Get priority color
  Color get priorityColor {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.amber;
      case Priority.low:
        return Colors.green;
    }
  }

  // Get status icon
  IconData get statusIcon {
    switch (status) {
      case TaskStatus.pending:
        return Icons.access_time;
      case TaskStatus.inProgress:
        return Icons.autorenew;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  // Get status color
  Color get statusColor {
    switch (status) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }
}

enum Priority { high, medium, low }
enum TaskStatus { pending, inProgress, completed }