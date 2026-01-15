import 'package:get/get.dart';
import 'package:myapp/models/event_model.dart';
import 'dart:math';

import '../../core/globals/global_variables.dart' as glbv;
class SchedulePageController extends GetxController {
 RxString userRole ="".obs;
 RxBool isLoading = true.obs;
  Rx<DateTime> selectedDate = DateTime
      .now()
      .obs;
  RxList<Event> events = <Event>[].obs;
  RxList<Event> upcomingEvents = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    updateUpcomingEvents();

  }

  void loadMockData() {
    userRole.value =glbv.role;
    events.clear();
    final now = DateTime.now();

    // Generate 5 random days including today
    final randomDays = _getRandomDaysInMonth(now, 5);

    for (var date in randomDays) {
      _addRoleSpecificEventsForDate(date);
    }

    update();
  }

  List<DateTime> _getRandomDaysInMonth(DateTime baseDate, int count) {
    final days = <DateTime>[];
    final now = DateTime.now();

    // Always include today
    days.add(DateTime(now.year, now.month, now.day));

    // Get remaining random days
    final random = Random();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    while (days.length < count) {
      final randomDay = random.nextInt(daysInMonth) + 1;
      final date = DateTime(now.year, now.month, randomDay);

      // Don't duplicate days
      if (!days.any((d) => d.day == date.day)) {
        days.add(date);
      }
    }

    return days;
  }

  void _addRoleSpecificEventsForDate(DateTime date) {
    switch (glbv.role) {
      case 'patient':
        _addPatientEvents(date);
        break;
      case 'therapist':
        _addTherapistEvents(date);
        break;
      case 'therapy_center':
        _addTherapyCenterEvents(date);
        break;
    }
  }

  void _addPatientEvents(DateTime date) {
    // Morning routine
    events.add(Event(
      id: '${date.day}_1',
      title: 'Morning Meditation',
      description: '15 minutes of mindfulness meditation',
      startTime: DateTime(date.year, date.month, date.day, 7, 0),
      endTime: DateTime(date.year, date.month, date.day, 7, 15),
      color: 0xFF2DD4BF,
      type: 'mindfulness',
      priority: 'medium',
    ));

    // Breakfast from diet plan
    events.add(Event(
      id: '${date.day}_2',
      title: 'Healthy Breakfast',
      description: 'Oatmeal with fruits and nuts',
      startTime: DateTime(date.year, date.month, date.day, 8, 0),
      endTime: DateTime(date.year, date.month, date.day, 8, 30),
      color: 0xFF10B981,
      type: 'nutrition',
      priority: 'high',
    ));

    // Morning exercise
    events.add(Event(
      id: '${date.day}_3',
      title: 'Morning Stretching',
      description: '15 minutes of stretching exercises',
      startTime: DateTime(date.year, date.month, date.day, 9, 0),
      endTime: DateTime(date.year, date.month, date.day, 9, 15),
      color: 0xFF3B82F6,
      type: 'exercise',
      priority: 'medium',
    ));

    // Lunch - broccoli meal
    events.add(Event(
      id: '${date.day}_4',
      title: 'Lunch - Grilled Chicken with Broccoli',
      description: 'Balanced meal with protein and vegetables',
      startTime: DateTime(date.year, date.month, date.day, 13, 0),
      endTime: DateTime(date.year, date.month, date.day, 13, 30),
      color: 0xFF10B981,
      type: 'nutrition',
      priority: 'high',
    ));

    // Afternoon therapy session
    if (date.day % 2 == 0) { // Every other day
      events.add(Event(
        id: '${date.day}_5',
        title: 'Physical Therapy Session',
        description: 'Leg strengthening exercises with therapist',
        startTime: DateTime(date.year, date.month, date.day, 15, 0),
        endTime: DateTime(date.year, date.month, date.day, 16, 0),
        color: 0xFF0D9488,
        type: 'therapy',
        priority: 'high',
      ));
    }

    // Evening walk
    events.add(Event(
      id: '${date.day}_6',
      title: 'Evening Walk',
      description: '30 minutes brisk walk in park',
      startTime: DateTime(date.year, date.month, date.day, 18, 0),
      endTime: DateTime(date.year, date.month, date.day, 18, 30),
      color: 0xFF3B82F6,
      type: 'exercise',
      priority: 'medium',
    ));

    // Dinner
    events.add(Event(
      id: '${date.day}_7',
      title: 'Light Dinner',
      description: 'Grilled fish with steamed vegetables',
      startTime: DateTime(date.year, date.month, date.day, 19, 30),
      endTime: DateTime(date.year, date.month, date.day, 20, 0),
      color: 0xFF10B981,
      type: 'nutrition',
      priority: 'high',
    ));

    // Medication reminder
    events.add(Event(
      id: '${date.day}_8',
      title: 'Evening Medication',
      description: 'Take prescribed medicines',
      startTime: DateTime(date.year, date.month, date.day, 21, 0),
      endTime: DateTime(date.year, date.month, date.day, 21, 15),
      color: 0xFFEF4444,
      type: 'medication',
      priority: 'high',
    ));
  }

  void _addTherapistEvents(DateTime date) {
    // Morning patient review
    events.add(Event(
      id: '${date.day}_1',
      title: 'Review Patient Reports',
      description: 'Daily review of assigned patient progress reports',
      startTime: DateTime(date.year, date.month, date.day, 8, 0),
      endTime: DateTime(date.year, date.month, date.day, 9, 0),
      color: 0xFF8B5CF6,
      type: 'review',
      priority: 'high',
    ));

    // Therapy session with patient
    events.add(Event(
      id: '${date.day}_2',
      title: 'Therapy Session - Ankush',
      description: 'Physical therapy session focusing on mobility',
      startTime: DateTime(date.year, date.month, date.day, 10, 0),
      endTime: DateTime(date.year, date.month, date.day, 11, 0),
      color: 0xFF0D9488,
      type: 'therapy',
      priority: 'high',
    ));

    // Create new diet plan
    if (date.day % 3 == 0) { // Every 3 days
      events.add(Event(
        id: '${date.day}_3',
        title: 'Create New Diet Plan',
        description: 'Develop weekly meal plan for patient Sarah',
        startTime: DateTime(date.year, date.month, date.day, 11, 30),
        endTime: DateTime(date.year, date.month, date.day, 12, 30),
        color: 0xFF10B981,
        type: 'nutrition',
        priority: 'medium',
      ));
    }

    // Lunch break
    events.add(Event(
      id: '${date.day}_4',
      title: 'Lunch Break',
      description: 'Take a break and recharge',
      startTime: DateTime(date.year, date.month, date.day, 13, 0),
      endTime: DateTime(date.year, date.month, date.day, 14, 0),
      color: 0xFF6B7280,
      type: 'break',
      priority: 'low',
    ));

    // Patient assessment
    events.add(Event(
      id: '${date.day}_5',
      title: 'Patient Progress Assessment',
      description: 'Assess John\'s recovery progress',
      startTime: DateTime(date.year, date.month, date.day, 14, 30),
      endTime: DateTime(date.year, date.month, date.day, 15, 30),
      color: 0xFFF59E0B,
      type: 'assessment',
      priority: 'high',
    ));

    // Update treatment plans
    events.add(Event(
      id: '${date.day}_6',
      title: 'Update Treatment Plans',
      description: 'Update therapy plans for assigned patients',
      startTime: DateTime(date.year, date.month, date.day, 16, 0),
      endTime: DateTime(date.year, date.month, date.day, 17, 0),
      color: 0xFF8B5CF6,
      type: 'planning',
      priority: 'medium',
    ));

    // Documentation
    events.add(Event(
      id: '${date.day}_7',
      title: 'Session Documentation',
      description: 'Document today\'s therapy sessions',
      startTime: DateTime(date.year, date.month, date.day, 17, 30),
      endTime: DateTime(date.year, date.month, date.day, 18, 30),
      color: 0xFF6B7280,
      type: 'documentation',
      priority: 'medium',
    ));
  }

  void _addTherapyCenterEvents(DateTime date) {
    // Morning staff meeting
    events.add(Event(
      id: '${date.day}_1',
      title: 'Daily Staff Meeting',
      description: 'Review center operations and patient updates',
      startTime: DateTime(date.year, date.month, date.day, 9, 0),
      endTime: DateTime(date.year, date.month, date.day, 10, 0),
      color: 0xFF0D9488,
      type: 'meeting',
      priority: 'high',
    ));

    // Interview new therapist
    if (date.day % 4 == 0) { // Every 4 days
      events.add(Event(
        id: '${date.day}_2',
        title: 'Interview New Therapist',
        description: 'Interview candidate for physiotherapist position',
        startTime: DateTime(date.year, date.month, date.day, 10, 30),
        endTime: DateTime(date.year, date.month, date.day, 11, 30),
        color: 0xFF8B5CF6,
        type: 'interview',
        priority: 'high',
      ));
    }

    // Onboard new child
    if (date.day % 5 == 0) { // Every 5 days
      events.add(Event(
        id: '${date.day}_3',
        title: 'Onboard New Child',
        description: 'Initial assessment and registration for new patient',
        startTime: DateTime(date.year, date.month, date.day, 11, 30),
        endTime: DateTime(date.year, date.month, date.day, 12, 30),
        color: 0xFF10B981,
        type: 'onboarding',
        priority: 'high',
      ));
    }

    // Lunch
    events.add(Event(
      id: '${date.day}_4',
      title: 'Lunch',
      description: '',
      startTime: DateTime(date.year, date.month, date.day, 13, 0),
      endTime: DateTime(date.year, date.month, date.day, 14, 0),
      color: 0xFF6B7280,
      type: 'break',
      priority: 'low',
    ));

    // Assign therapist to new child
    events.add(Event(
      id: '${date.day}_5',
      title: 'Assign Therapist to New Case',
      description: 'Match therapist with new patient based on specialization',
      startTime: DateTime(date.year, date.month, date.day, 14, 30),
      endTime: DateTime(date.year, date.month, date.day, 15, 30),
      color: 0xFF0D9488,
      type: 'assignment',
      priority: 'high',
    ));

    // Equipment maintenance check
    events.add(Event(
      id: '${date.day}_6',
      title: 'Equipment Maintenance Check',
      description: 'Inspect therapy equipment and schedule maintenance',
      startTime: DateTime(date.year, date.month, date.day, 15, 45),
      endTime: DateTime(date.year, date.month, date.day, 16, 45),
      color: 0xFFF59E0B,
      type: 'maintenance',
      priority: 'medium',
    ));

    // Review center performance
    events.add(Event(
      id: '${date.day}_7',
      title: 'Review Center Performance Metrics',
      description: 'Analyze patient outcomes and therapist performance',
      startTime: DateTime(date.year, date.month, date.day, 17, 0),
      endTime: DateTime(date.year, date.month, date.day, 18, 0),
      color: 0xFF8B5CF6,
      type: 'performance',
      priority: 'medium',
    ));
  }

  // Helper method to shift today's tasks to next 5 hours
  void _shiftTodayTasksToNext5Hours() {
    final now = DateTime.now();
    final fiveHoursLater = now.add(Duration(hours: 5));

    // Adjust times for today's events to fall within next 5 hours
    for (var event in events) {
      if (event.startTime.year == now.year &&
          event.startTime.month == now.month &&
          event.startTime.day == now.day) {
        // If event is in past, move it to near future within next 5 hours
        if (event.startTime.isBefore(now)) {
          final hoursFromNow = Random().nextInt(4) + 1; // 1-4 hours from now
          final minutes = Random().nextInt(60);
          event = event.copyWith(startTime: now.add(
              Duration(hours: hoursFromNow, minutes: minutes)),
              endTime: event.startTime.add(Duration(minutes: 30)));
        }
      }
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    updateUpcomingEvents();
  }

  void updateUpcomingEvents() {
    final now = DateTime.now();
    final fiveHoursLater = now.add(const Duration(hours: 5));

    upcomingEvents.value = events.where((event) {
      return event.startTime.isAfter(now) &&
          event.startTime.isBefore(fiveHoursLater);
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    update();
    isLoading.value=false;
  }

  void addEvent(Event event) {
    events.add(event);
    updateUpcomingEvents();
  }

  void deleteEvent(String eventId) {
    events.removeWhere((event) => event.id == eventId);
    updateUpcomingEvents();
  }


}

