class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final int color;
  final String type;
  final String priority;
  final String? assignedTo;
  final String? location;
  final bool? isCompleted;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.type,
    required this.priority,
    this.assignedTo,
    this.location,
    this.isCompleted = false,
  });

  String get timeRange {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? color,
    String? type,
    String? priority,
    String? assignedTo,
    String? location,
    bool? isCompleted,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}