import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TherapistDashboardController extends GetxController {
  // Reactive variables
  var currentRating = 4.5.obs;
  var totalChildren = 15.obs;
  var pendingTasks = 7.obs;
  var completedSessions = 32.obs;

  // Sample data for charts
  List<ChartData> progressData = [
    ChartData('Week 1', 65),
    ChartData('Week 2', 72),
    ChartData('Week 3', 68),
    ChartData('Week 4', 85),
    ChartData('Week 5', 90),
    ChartData('Week 6', 88),
  ];

  List<ChartData> sessionData = [
    ChartData('Mon', 5),
    ChartData('Tue', 8),
    ChartData('Wed', 6),
    ChartData('Thu', 7),
    ChartData('Fri', 9),
    ChartData('Sat', 4),
  ];

  // Calendar appointments
  List<Appointment> get appointments => [
    Appointment(
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      subject: 'Session with Alex',
      color: Colors.teal,
    ),
    Appointment(
      startTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
      subject: 'Progress Review',
      color: Colors.teal.shade300,
    ),
    Appointment(
      startTime: DateTime.now().add(const Duration(days: 2, hours: 14)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 15)),
      subject: 'Parent Meeting',
      color: Colors.teal.shade400,
    ),
  ];

  // Children list
  List<ChildData> childrenList = [
    ChildData('Alex Johnson', 'Autism Spectrum', 78, Colors.teal),
    ChildData('Sarah Miller', 'Speech Delay', 85, Colors.teal.shade300),
    ChildData('James Wilson', 'ADHD', 65, Colors.teal.shade400),
    ChildData('Emma Davis', 'Motor Skills', 92, Colors.teal.shade200),
  ];

  // Tasks list
  List<TaskData> tasksList = [
    TaskData('Complete Session Notes for Alex', true),
    TaskData('Review Progress Reports', false),
    TaskData('Update Therapy Plans', false),
    TaskData('Prepare Assessment Tools', true),
  ];
}

// Data classes
class ChartData {
  final String week;
  final double progress;

  ChartData(this.week, this.progress);
}

class ChildData {
  final String name;
  final String condition;
  final int progress;
  final Color color;

  ChildData(this.name, this.condition, this.progress, this.color);
}

class TaskData {
  final String title;
  final bool isCompleted;

  TaskData(this.title, this.isCompleted);
}