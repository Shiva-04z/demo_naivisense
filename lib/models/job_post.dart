import 'dart:convert';

class JobPost {
  final String id;
  final String title;
  final String organization;
  final String location;
  final String salary; // In INR format (per month)
  final String salaryRange; // Additional display format
  final String type; // Full-time, Part-time, Contract, Internship
  final String postedDate;
  final String deadline;
  final List<String> requirements;
  final String description;
  final String therapyType; // Changed from department to therapyType
  final String experience;
  final bool isApplied;
  final DateTime? appliedDate;
  final bool isUrgent;
  final bool isRemote;
  final bool isWalkIn;
  final List<String> benefits;
  final String contactEmail;
  final String contactPhone;
  final int minSalary; // For filtering (in thousands)
  final int maxSalary; // For filtering (in thousands)
  final String shift; // Day, Night, Flexible
  final int vacancies;
  final String qualification;
  final String specialization; // Specific therapy specialization

  JobPost({
    required this.id,
    required this.title,
    required this.organization,
    required this.location,
    required this.salary,
    required this.salaryRange,
    required this.type,
    required this.postedDate,
    required this.deadline,
    required this.requirements,
    required this.description,
    required this.therapyType,
    required this.experience,
    this.isApplied = false,
    this.appliedDate,
    this.isUrgent = false,
    this.isRemote = false,
    this.isWalkIn = false,
    this.benefits = const [],
    this.contactEmail = '',
    this.contactPhone = '',
    required this.minSalary,
    required this.maxSalary,
    required this.shift,
    required this.vacancies,
    required this.qualification,
    required this.specialization,
  });

  // Copy with method
  JobPost copyWith({
    String? id,
    String? title,
    String? organization,
    String? location,
    String? salary,
    String? salaryRange,
    String? type,
    String? postedDate,
    String? deadline,
    List<String>? requirements,
    String? description,
    String? therapyType,
    String? experience,
    bool? isApplied,
    DateTime? appliedDate,
    bool? isUrgent,
    bool? isRemote,
    bool? isWalkIn,
    List<String>? benefits,
    String? contactEmail,
    String? contactPhone,
    int? minSalary,
    int? maxSalary,
    String? shift,
    int? vacancies,
    String? qualification,
    String? specialization,
  }) {
    return JobPost(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      salaryRange: salaryRange ?? this.salaryRange,
      type: type ?? this.type,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      requirements: requirements ?? this.requirements,
      description: description ?? this.description,
      therapyType: therapyType ?? this.therapyType,
      experience: experience ?? this.experience,
      isApplied: isApplied ?? this.isApplied,
      appliedDate: appliedDate ?? this.appliedDate,
      isUrgent: isUrgent ?? this.isUrgent,
      isRemote: isRemote ?? this.isRemote,
      isWalkIn: isWalkIn ?? this.isWalkIn,
      benefits: benefits ?? this.benefits,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      shift: shift ?? this.shift,
      vacancies: vacancies ?? this.vacancies,
      qualification: qualification ?? this.qualification,
      specialization: specialization ?? this.specialization,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'location': location,
      'salary': salary,
      'salaryRange': salaryRange,
      'type': type,
      'postedDate': postedDate,
      'deadline': deadline,
      'requirements': requirements,
      'description': description,
      'therapyType': therapyType,
      'experience': experience,
      'isApplied': isApplied,
      'appliedDate': appliedDate?.toIso8601String(),
      'isUrgent': isUrgent,
      'isRemote': isRemote,
      'isWalkIn': isWalkIn,
      'benefits': benefits,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'shift': shift,
      'vacancies': vacancies,
      'qualification': qualification,
      'specialization': specialization,
    };
  }

  // Create from Map
  factory JobPost.fromMap(Map<String, dynamic> map) {
    return JobPost(
      id: map['id'] as String,
      title: map['title'] as String,
      organization: map['organization'] as String,
      location: map['location'] as String,
      salary: map['salary'] as String,
      salaryRange: map['salaryRange'] as String,
      type: map['type'] as String,
      postedDate: map['postedDate'] as String,
      deadline: map['deadline'] as String,
      requirements: List<String>.from(map['requirements']),
      description: map['description'] as String,
      therapyType: map['therapyType'] as String,
      experience: map['experience'] as String,
      isApplied: map['isApplied'] as bool,
      appliedDate: map['appliedDate'] != null
          ? DateTime.parse(map['appliedDate'] as String)
          : null,
      isUrgent: map['isUrgent'] as bool,
      isRemote: map['isRemote'] as bool,
      isWalkIn: map['isWalkIn'] as bool,
      benefits: List<String>.from(map['benefits']),
      contactEmail: map['contactEmail'] as String,
      contactPhone: map['contactPhone'] as String,
      minSalary: map['minSalary'] as int,
      maxSalary: map['maxSalary'] as int,
      shift: map['shift'] as String,
      vacancies: map['vacancies'] as int,
      qualification: map['qualification'] as String,
      specialization: map['specialization'] as String,
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Create from JSON
  factory JobPost.fromJson(String source) =>
      JobPost.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobPost && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Get formatted salary with LPA or per month
  String get formattedSalary {
    if (salary.contains('LPA')) {
      return '₹$salary';
    }
    return '₹$salary per month';
  }

  // Get salary for filtering (average in thousands)
  int get averageSalary => ((minSalary + maxSalary) ~/ 2);

  // Check if salary is in range
  bool isSalaryInRange(int min, int max) {
    return averageSalary >= min && averageSalary <= max;
  }

  // Get therapy type color
  String get therapyColor {
    switch (therapyType.toLowerCase()) {
      case 'physical therapy':
        return '#E53935'; // Red
      case 'occupational therapy':
        return '#43A047'; // Green
      case 'speech therapy':
        return '#3949AB'; // Indigo
      case 'psychotherapy':
        return '#8E24AA'; // Purple
      case 'respiratory therapy':
        return '#0097A7'; // Teal
      case 'music therapy':
        return '#D81B60'; // Pink
      case 'art therapy':
        return '#5D4037'; // Brown
      case 'dance therapy':
        return '#F57C00'; // Deep Orange
      case 'recreational therapy':
        return '#7B1FA2'; // Deep Purple
      case 'massage therapy':
        return '#00897B'; // Teal 700
      case 'aquatic therapy':
        return '#039BE5'; // Light Blue 600
      default:
        return '#008080'; // Primary Teal
    }
  }

  // Get time remaining for application
  String get timeRemaining {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final difference = deadlineDate.difference(now);

      if (difference.inDays > 0) {
        return '${difference.inDays} days left';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours left';
      }
      return 'Expires today';
    } catch (e) {
      return 'Apply by: $deadline';
    }
  }

  // Check if job is expired
  bool get isExpired {
    try {
      final deadlineDate = DateTime.parse(deadline);
      return deadlineDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // Get therapy icon
  String get therapyIcon {
    switch (therapyType.toLowerCase()) {
      case 'physical therapy':
        return '💪';
      case 'occupational therapy':
        return '👨‍💼';
      case 'speech therapy':
        return '🗣️';
      case 'psychotherapy':
        return '🧠';
      case 'respiratory therapy':
        return '🫁';
      case 'music therapy':
        return '🎵';
      case 'art therapy':
        return '🎨';
      case 'dance therapy':
        return '💃';
      case 'recreational therapy':
        return '⚽';
      case 'massage therapy':
        return '💆';
      case 'aquatic therapy':
        return '🏊';
      default:
        return '🩺';
    }
  }
}

class PostedJob {
  final String id;
  final String title;
  final String therapyType;
  final String location;
  final String salaryRange;
  final String type;
  final String experience;
  final String description;
  final List<String> requirements;
  final List<String> benefits;
  final String deadline;
  final int vacancies;
  final DateTime postedDate;
  final bool isActive;
  final int applicantsCount;
  final int shortlistedCount;

  PostedJob({
    required this.id,
    required this.title,
    required this.therapyType,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.experience,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.deadline,
    required this.vacancies,
    required this.postedDate,
    this.isActive = true,
    this.applicantsCount = 0,
    this.shortlistedCount = 0,
  });

  PostedJob copyWith({
    String? id,
    String? title,
    String? therapyType,
    String? location,
    String? salaryRange,
    String? type,
    String? experience,
    String? description,
    List<String>? requirements,
    List<String>? benefits,
    String? deadline,
    int? vacancies,
    DateTime? postedDate,
    bool? isActive,
    int? applicantsCount,
    int? shortlistedCount,
  }) {
    return PostedJob(
      id: id ?? this.id,
      title: title ?? this.title,
      therapyType: therapyType ?? this.therapyType,
      location: location ?? this.location,
      salaryRange: salaryRange ?? this.salaryRange,
      type: type ?? this.type,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      deadline: deadline ?? this.deadline,
      vacancies: vacancies ?? this.vacancies,
      postedDate: postedDate ?? this.postedDate,
      isActive: isActive ?? this.isActive,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      shortlistedCount: shortlistedCount ?? this.shortlistedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'therapyType': therapyType,
      'location': location,
      'salaryRange': salaryRange,
      'type': type,
      'experience': experience,
      'description': description,
      'requirements': requirements,
      'benefits': benefits,
      'deadline': deadline,
      'vacancies': vacancies,
      'postedDate': postedDate.toIso8601String(),
      'isActive': isActive,
      'applicantsCount': applicantsCount,
      'shortlistedCount': shortlistedCount,
    };
  }

  factory PostedJob.fromMap(Map<String, dynamic> map) {
    return PostedJob(
      id: map['id'] as String,
      title: map['title'] as String,
      therapyType: map['therapyType'] as String,
      location: map['location'] as String,
      salaryRange: map['salaryRange'] as String,
      type: map['type'] as String,
      experience: map['experience'] as String,
      description: map['description'] as String,
      requirements: List<String>.from(map['requirements']),
      benefits: List<String>.from(map['benefits']),
      deadline: map['deadline'] as String,
      vacancies: map['vacancies'] as int,
      postedDate: DateTime.parse(map['postedDate'] as String),
      isActive: map['isActive'] as bool,
      applicantsCount: map['applicantsCount'] as int,
      shortlistedCount: map['shortlistedCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());
  factory PostedJob.fromJson(String source) => PostedJob.fromMap(json.decode(source));
}

class Applicant {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String experience;
  final String qualification;
  final String resumeUrl;
  final String coverLetter;
  final DateTime appliedDate;
  final String status; // Applied, Shortlisted, Rejected, Hired
  final double matchScore; // 0-100
  final String jobId;
  final String jobTitle;

  Applicant({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
    required this.qualification,
    required this.resumeUrl,
    required this.coverLetter,
    required this.appliedDate,
    this.status = 'Applied',
    this.matchScore = 0.0,
    required this.jobId,
    required this.jobTitle,
  });

  Applicant copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? experience,
    String? qualification,
    String? resumeUrl,
    String? coverLetter,
    DateTime? appliedDate,
    String? status,
    double? matchScore,
    String? jobId,
    String? jobTitle,
  }) {
    return Applicant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetter: coverLetter ?? this.coverLetter,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      matchScore: matchScore ?? this.matchScore,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }

  String get statusColor {
    switch (status) {
      case 'Shortlisted':
        return '#4CAF50';
      case 'Rejected':
        return '#E53935';
      case 'Hired':
        return '#008080';
      default:
        return '#D4AF37';
    }
  }

  String get statusIcon {
    switch (status) {
      case 'Shortlisted':
        return '✓';
      case 'Rejected':
        return '✗';
      case 'Hired':
        return '★';
      default:
        return '📄';
    }
  }
}