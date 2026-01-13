import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimelineEvent {
  final String title;
  final String description;
  final DateTime date;
  final IconData icon;
  final Color color;
  final String type; // 'task', 'diet', 'therapy', 'test', 'milestone'

  TimelineEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class ImprovementMetric {
  final String category;
  final double currentScore;
  final double previousScore;
  final Color color;
  final IconData icon;

  ImprovementMetric({
    required this.category,
    required this.currentScore,
    required this.previousScore,
    required this.color,
    required this.icon,
  });

  double get improvement => currentScore - previousScore;
  double get percentage => ((currentScore - previousScore) / previousScore * 100);
}

// Add these new classes to your parent_dashboard_controller.dart
class Milestone {
  final String title;
  final DateTime date;
  final String description;
  final IconData icon;
  final Color color;
  final double value; // For positioning on Y-axis

  Milestone({
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
    required this.color,
    required this.value,
  });
}

// Add to ParentDashboardController class


// Add method to combine events and milestones


class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String priority; // 'high', 'medium', 'low'
  final String category; // 'exercise', 'diet', 'therapy', 'other'

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
    required this.category,
  });
}

class ParentDashboardController extends GetxController {
  final RxString selectedTimeRange = 'Weekly'.obs;
  final RxInt currentPageIndex = 0.obs;

  final List<String> timeRanges = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  final List<Milestone> milestones = [
    Milestone(
      title: 'First Words',
      date: DateTime.now().subtract(Duration(days: 25)),
      description: 'Said 5 new words',
      icon: Icons.mic,
      color: Color(0xFF4CAF50),
      value: 1.0,
    ),
    Milestone(
      title: 'Social Interaction',
      date: DateTime.now().subtract(Duration(days: 18)),
      description: 'Played with peers for 15 minutes',
      icon: Icons.group,
      color: Color(0xFF2196F3),
      value: 2.0,
    ),
    Milestone(
      title: 'Motor Skills',
      date: DateTime.now().subtract(Duration(days: 10)),
      description: 'Held pencil correctly',
      icon: Icons.create,
      color: Color(0xFFFF9800),
      value: 3.0,
    ),
    Milestone(
      title: 'Behavior Progress',
      date: DateTime.now().subtract(Duration(days: 5)),
      description: 'Reduced tantrums by 40%',
      icon: Icons.emoji_emotions,
      color: Color(0xFF9C27B0),
      value: 4.0,
    ),
  ];
  // Mock data for tasks
  final List<Task> tasks = [
    Task(
      title: 'Speech Therapy Exercises',
      description: 'Practice vowel sounds for 15 minutes',
      dueDate: DateTime.now().add(Duration(days: 1)),
      isCompleted: false,
      priority: 'high',
      category: 'therapy',
    ),
    Task(
      title: 'Occupational Therapy Activities',
      description: 'Fine motor skills practice with beads',
      dueDate: DateTime.now().add(Duration(days: 2)),
      isCompleted: true,
      priority: 'medium',
      category: 'therapy',
    ),
    Task(
      title: 'Gluten-free Diet Day',
      description: 'Follow gluten-free meal plan',
      dueDate: DateTime.now(),
      isCompleted: false,
      priority: 'high',
      category: 'diet',
    ),
    Task(
      title: 'Sensory Play Session',
      description: '30 minutes of sensory integration',
      dueDate: DateTime.now().add(Duration(days: 3)),
      isCompleted: false,
      priority: 'medium',
      category: 'therapy',
    ),
  ];

  // Mock data for improvement metrics
  final List<ImprovementMetric> improvementMetrics = [
    ImprovementMetric(
      category: 'Communication',
      currentScore: 85,
      previousScore: 70,
      color: Color(0xFF4CAF50),
      icon: Icons.chat_bubble,
    ),
    ImprovementMetric(
      category: 'Social Skills',
      currentScore: 72,
      previousScore: 60,
      color: Color(0xFF2196F3),
      icon: Icons.group,
    ),
    ImprovementMetric(
      category: 'Motor Skills',
      currentScore: 90,
      previousScore: 75,
      color: Color(0xFFFF9800),
      icon: Icons.directions_run,
    ),
    ImprovementMetric(
      category: 'Behavior',
      currentScore: 68,
      previousScore: 50,
      color: Color(0xFF9C27B0),
      icon: Icons.psychology,
    ),
  ];

  // Mock data for timeline events
  final List<TimelineEvent> timelineEvents = [
    TimelineEvent(
      title: 'Task Assigned',
      description: 'Speech therapy exercises',
      date: DateTime.now().subtract(Duration(days: 30)),
      icon: Icons.task_alt,
      color: Color(0xFF4CAF50),
      type: 'task',
    ),
    TimelineEvent(
      title: 'Task Completed',
      description: 'First milestone achieved',
      date: DateTime.now().subtract(Duration(days: 28)),
      icon: Icons.check_circle,
      color: Color(0xFF2196F3),
      type: 'task',
    ),
    TimelineEvent(
      title: 'Diet Plan Attached',
      description: 'Gluten-free diet started',
      date: DateTime.now().subtract(Duration(days: 25)),
      icon: Icons.restaurant,
      color: Color(0xFFFF9800),
      type: 'diet',
    ),
    TimelineEvent(
      title: 'Therapist Assigned',
      description: 'Dr. Sarah Johnson - Speech Therapist',
      date: DateTime.now().subtract(Duration(days: 22)),
      icon: Icons.person,
      color: Color(0xFF9C27B0),
      type: 'therapy',
    ),
    TimelineEvent(
      title: 'Updated Diet Plan',
      description: 'Added new supplements',
      date: DateTime.now().subtract(Duration(days: 20)),
      icon: Icons.update,
      color: Color(0xFF00BCD4),
      type: 'diet',
    ),
    TimelineEvent(
      title: 'Home Plan Created',
      description: 'Daily activity schedule',
      date: DateTime.now().subtract(Duration(days: 18)),
      icon: Icons.home,
      color: Color(0xFFE91E63),
      type: 'task',
    ),
    TimelineEvent(
      title: 'Therapy Center Assigned',
      description: 'Bloom Therapy Center',
      date: DateTime.now().subtract(Duration(days: 15)),
      icon: Icons.local_hospital,
      color: Color(0xFF3F51B5),
      type: 'therapy',
    ),
    TimelineEvent(
      title: 'Second Therapist Assigned',
      description: 'Dr. Michael Chen - Occupational Therapist',
      date: DateTime.now().subtract(Duration(days: 12)),
      icon: Icons.person_add,
      color: Color(0xFF009688),
      type: 'therapy',
    ),
    TimelineEvent(
      title: 'Test Assigned',
      description: 'Progress assessment test',
      date: DateTime.now().subtract(Duration(days: 10)),
      icon: Icons.assignment,
      color: Color(0xFFFF5722),
      type: 'test',
    ),
    TimelineEvent(
      title: 'Test Results',
      description: 'Positive improvement in communication',
      date: DateTime.now().subtract(Duration(days: 7)),
      icon: Icons.assessment,
      color: Color(0xFF8BC34A),
      type: 'test',
    ),
  ];

  // Mock data for current plans
  final Map<String, dynamic> currentPlan = {
    'activeTherapy': 'Speech & Occupational Therapy',
    'dietPlan': 'Gluten-free with Omega-3 supplements',
    'exercisePlan': 'Daily fine motor exercises',
    'nextSession': 'Tomorrow, 10:00 AM',
    'center': 'Bloom Therapy Center',
    'therapist1': 'Dr. Sarah Johnson',
    'therapist2': 'Dr. Michael Chen',
    'therapist1Specialty': 'Speech Therapy',
    'therapist2Specialty': 'Occupational Therapy',
  };

  // Get progress percentage
  double getProgressPercentage() {
    int completed = tasks.where((task) => task.isCompleted).length;
    return completed / tasks.length;
  }

  // Get upcoming tasks
  List<Task> getUpcomingTasks() {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  // Get completed tasks
  List<Task> getCompletedTasks() {
    return tasks.where((task) => task.isCompleted).toList();
  }

  // Sort timeline events by date
  List<TimelineEvent> getSortedTimelineEvents() {
    return List.from(timelineEvents)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Chart data for improvement
  List<ChartData> getImprovementChartData() {
    return improvementMetrics.map((metric) {
      return ChartData(
        metric.category,
        metric.currentScore,
        metric.previousScore,
        metric.color,
      );
    }).toList();
  }

  // Chart data for weekly progress
  List<ChartData> getWeeklyProgressData() {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final Random random = Random();

    return days.map((day) {
      return ChartData(
        day,
        60 + random.nextDouble() * 40, // current
        40 + random.nextDouble() * 30, // previous
        Color(0xFF2196F3),
      );
    }).toList();
  }

  List<dynamic> getCombinedTimelineData() {
    final List<dynamic> combined = [];
    combined.addAll(timelineEvents);
    combined.addAll(milestones);
    combined.sort((a, b) => (a.date).compareTo(b.date));
    return combined;
  }

  void changeTimeRange(String range) {
    selectedTimeRange.value = range;
  }

  void changePageIndex(int index) {
    currentPageIndex.value = index;
  }
}

class ChartData {
  final String x;
  final double y1;
  final double y2;
  final Color color;

  ChartData(this.x, this.y1, this.y2, this.color);
}