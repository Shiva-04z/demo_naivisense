import 'package:get/get.dart';

import '../../models/event_model.dart';


class SchedulePageController extends GetxController {
  // User role (change this based on your authentication)
  RxString userRole = 'patient'.obs;

  // Selected date
  Rx<DateTime> selectedDate = DateTime.now().obs;

  // All events
  RxList<Event> events = <Event>[].obs;

  // Upcoming events within 5 hours
  RxList<Event> upcomingEvents = <Event>[].obs;

  // Mock therapists for assignment
  final List<String> therapists = [
    'Dr. Sarah Wilson',
    'Dr. Michael Chen',
    'Dr. Emily Rodriguez',
    'Dr. James Brown'
  ];

  // Mock patients for therapist view
  final List<String> patients = [
    'John Smith',
    'Emma Johnson',
    'Robert Davis',
    'Lisa Wang'
  ];

  // Mock therapy centers
  final List<String> therapyCenters = [
    'Harmony Therapy Center',
    'Wellness Institute',
    'Mind & Body Clinic'
  ];

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    updateUpcomingEvents();
  }

  void loadMockData() {
    final now = DateTime.now();

    // Common events for all roles
    events.assignAll([
      Event(
        id: '1',
        title: 'Morning Meditation',
        description: 'Start your day with mindfulness',
        startTime: DateTime(now.year, now.month, now.day, 8, 0),
        endTime: DateTime(now.year, now.month, now.day, 8, 30),
        color: 0xFF2DD4BF, // Teal
        type: 'mindfulness',
        priority: 'medium',
      ),
    ]);

    // Add role-specific events
    switch (userRole.value) {
      case 'patient':
        _loadPatientEvents(now);
        break;
      case 'therapist':
        _loadTherapistEvents(now);
        break;
      case 'therapy_center':
        _loadTherapyCenterEvents(now);
        break;
    }

    update();
  }

  void _loadPatientEvents(DateTime now) {
    events.addAll([
      Event(
        id: '2',
        title: 'Physical Therapy Session',
        description: 'Leg exercises with Dr. Wilson',
        startTime: DateTime(now.year, now.month, now.day, 10, 0),
        endTime: DateTime(now.year, now.month, now.day, 11, 0),
        color: 0xFF0D9488,
        type: 'therapy',
        priority: 'high',
      ),
      Event(
        id: '3',
        title: 'Diet Chart Review',
        description: 'Review weekly meal plan',
        startTime: DateTime(now.year, now.month, now.day, 12, 0),
        endTime: DateTime(now.year, now.month, now.day, 12, 30),
        color: 0xFF14B8A6,
        type: 'nutrition',
        priority: 'medium',
      ),
      Event(
        id: '4',
        title: 'Exercise Plan',
        description: 'Daily stretching routine',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0),
        color: 0xFF5EEAD4,
        type: 'exercise',
        priority: 'medium',
      ),
      Event(
        id: '5',
        title: 'Progress Test',
        description: 'Weekly assessment',
        startTime: DateTime(now.year, now.month, now.day, 16, 0),
        endTime: DateTime(now.year, now.month, now.day, 16, 30),
        color: 0xFF0F766E,
        type: 'assessment',
        priority: 'high',
      ),
    ]);
  }

  void _loadTherapistEvents(DateTime now) {
    events.addAll([
      Event(
        id: '6',
        title: 'Patient Review - John Smith',
        description: 'Review recovery progress',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 0),
        color: 0xFF0D9488,
        type: 'review',
        priority: 'high',
      ),
      Event(
        id: '7',
        title: 'New Job Interview',
        description: 'Interview at Wellness Center',
        startTime: DateTime(now.year, now.month, now.day, 11, 0),
        endTime: DateTime(now.year, now.month, now.day, 12, 0),
        color: 0xFF14B8A6,
        type: 'interview',
        priority: 'high',
      ),
      Event(
        id: '8',
        title: 'Assign Diet Chart',
        description: 'Create meal plan for Emma',
        startTime: DateTime(now.year, now.month, now.day, 13, 0),
        endTime: DateTime(now.year, now.month, now.day, 13, 30),
        color: 0xFF5EEAD4,
        type: 'assignment',
        priority: 'medium',
      ),
      Event(
        id: '9',
        title: 'Team Meeting',
        description: 'Weekly staff meeting',
        startTime: DateTime(now.year, now.month, now.day, 15, 0),
        endTime: DateTime(now.year, now.month, now.day, 16, 0),
        color: 0xFF0F766E,
        type: 'meeting',
        priority: 'medium',
      ),
    ]);
  }

  void _loadTherapyCenterEvents(DateTime now) {
    events.addAll([
      Event(
        id: '10',
        title: 'New Therapist Interview',
        description: 'Interview with Dr. Patel',
        startTime: DateTime(now.year, now.month, now.day, 9, 30),
        endTime: DateTime(now.year, now.month, now.day, 10, 30),
        color: 0xFF0D9488,
        type: 'interview',
        priority: 'high',
      ),
      Event(
        id: '11',
        title: 'Child Progress Review',
        description: 'Review Bobby\'s therapy progress',
        startTime: DateTime(now.year, now.month, now.day, 11, 30),
        endTime: DateTime(now.year, now.month, now.day, 12, 30),
        color: 0xFF14B8A6,
        type: 'review',
        priority: 'medium',
      ),
      Event(
        id: '12',
        title: 'Therapist Performance Review',
        description: 'Monthly performance metrics',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0),
        color: 0xFF5EEAD4,
        type: 'performance',
        priority: 'high',
      ),
      Event(
        id: '13',
        title: 'Equipment Maintenance',
        description: 'Therapy equipment check',
        startTime: DateTime(now.year, now.month, now.day, 15, 30),
        endTime: DateTime(now.year, now.month, now.day, 16, 30),
        color: 0xFF0F766E,
        type: 'maintenance',
        priority: 'low',
      ),
    ]);
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
  }

  void addEvent(Event event) {
    events.add(event);
    updateUpcomingEvents();
  }

  void deleteEvent(String eventId) {
    events.removeWhere((event) => event.id == eventId);
    updateUpcomingEvents();
  }

  void changeUserRole(String role) {
    userRole.value = role;
    loadMockData();
    updateUpcomingEvents();
  }
}