import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/globals/dummy_data.dart';
 // Import your dummy data

class TherapistDashboardController extends GetxController {
  // Reactive variables
  var currentRating = 4.8.obs;
  var totalChildren = 0.obs;
  var pendingTasks = 0.obs;
  var completedSessions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    // Get therapists from dummy data and set stats
    final therapists = DummyData.getTherapists();
    if (therapists.isNotEmpty) {
      // Set random rating between 4.0 and 5.0
      currentRating.value = 4.0 + (DateTime.now().millisecondsSinceEpoch % 100) / 100.0;
    }

    // Get associated patients (children)
    final patients = DummyData.getPatients();
    totalChildren.value = patients.length;

    // Count pending tasks
    pendingTasks.value = tasksList.where((task) => !task.isCompleted).length;

    // Calculate completed sessions (using random logic based on patient count)
    completedSessions.value = (patients.length * 2) + (DateTime.now().day % 5);
  }

  // Sample data for charts
  List<ChartData> get progressData {
    final patients = DummyData.getPatients();
    return [
      ChartData('Week 1', 60 + (patients.length % 20).toDouble()),
      ChartData('Week 2', 65 + (patients.length % 25).toDouble()),
      ChartData('Week 3', 70 + (patients.length % 30).toDouble()),
      ChartData('Week 4', 75 + (patients.length % 35).toDouble()),
      ChartData('Week 5', 80 + (patients.length % 40).toDouble()),
      ChartData('Week 6', 85 + (patients.length % 45).toDouble()),
    ];
  }

  List<ChartData> get sessionData {
    return [
      ChartData('Mon', 5 + (DateTime.now().day % 3).toDouble()),
      ChartData('Tue', 8 + (DateTime.now().day % 4).toDouble()),
      ChartData('Wed', 6 + (DateTime.now().day % 2).toDouble()),
      ChartData('Thu', 7 + (DateTime.now().day % 5).toDouble()),
      ChartData('Fri', 9 + (DateTime.now().day % 6).toDouble()),
      ChartData('Sat', 4 + (DateTime.now().day % 3).toDouble()),
    ];
  }

  // Calendar appointments based on dummy data patients
  List<Appointment> get appointments {
    final patients = DummyData.getPatients();
    final now = DateTime.now();
    List<Appointment> appointmentsList = [];

    // Create appointments for the next few days
    for (int i = 0; i < patients.length && i < 5; i++) {
      final patient = patients[i];
      appointmentsList.add(
        Appointment(
          startTime: now.add(Duration(days: i, hours: 9 + (i % 4))),
          endTime: now.add(Duration(days: i, hours: 10 + (i % 4))),
          subject: 'Session with ${patient.name.split(' ')[0]}',
          color: Colors.teal.withOpacity(0.7 + (i * 0.05)),
          notes: patient.specialization ?? 'General Session',
        ),
      );
    }

    return appointmentsList;
  }

  // Children list from dummy data patients
  List<ChildData> get childrenList {
    final patients = DummyData.getPatients();

    // Define a list of colors for progress circles
    final colors = [
      Colors.teal,
      Colors.teal.shade300,
      Colors.teal.shade400,
      Colors.teal.shade200,
      Colors.teal.shade600,
      Colors.teal.shade100,
    ];

    // Create ChildData from patients
    return patients.take(6).map((patient) {
      final index = patients.indexOf(patient);
      return ChildData(
        patient.name,
        patient.specialization ?? 'General Therapy',
        (60 + (index * 5)).clamp(60, 95), // Progress between 60-95%
        colors[index % colors.length],
      );
    }).toList();
  }

  // Tasks list
  List<TaskData> get tasksList {
    final patients = DummyData.getPatients();
    return [
      TaskData('Complete Session Notes for ${patients.isNotEmpty ? patients[0].name : "Patient"}',
          DateTime.now().day % 3 == 0),
      TaskData('Review Progress Reports', DateTime.now().day % 4 == 0),
      TaskData('Update Therapy Plans for ${patients.length} patients', false),
      TaskData('Prepare Assessment Tools', DateTime.now().day % 2 == 0),
      TaskData('Follow up with ${patients.length > 1 ? patients[1].name : "Patient"}',
          false),
      TaskData('Schedule Next Month Sessions', DateTime.now().day % 5 == 0),
      TaskData('Review Lab Results', false),
      TaskData('Update Patient Records', DateTime.now().day % 6 == 0),
    ];
  }
}

// Data classes (keep existing)
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