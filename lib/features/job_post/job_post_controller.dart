import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/job_post.dart';


class JobPostController extends GetxController {
  // Tab Index
  final selectedTabIndex = 0.obs;

  // Post Job Form Observables
  final jobTitle = ''.obs;
  final therapyType = ''.obs;
  final location = ''.obs;
  final salaryRange = ''.obs;
  final jobType = ''.obs;
  final experienceLevel = ''.obs;
  final jobDescription = ''.obs;
  final requirements = <String>[].obs;
  final benefits = <String>[].obs;
  final deadline = ''.obs;
  final vacancies = 1.obs;
  final isFormValid = false.obs;
  final isPostingJob = false.obs;

  // Posted Jobs Observables
  final postedJobs = <PostedJob>[].obs;
  final filteredPostedJobs = <PostedJob>[].obs;
  final searchPostedQuery = ''.obs;
  final filterStatus = 'All'.obs;

  // Applicants Observables
  final allApplicants = <Applicant>[].obs;
  final filteredApplicants = <Applicant>[].obs;
  final searchApplicantQuery = ''.obs;
  final filterApplicantStatus = 'All'.obs;
  final selectedJobFilter = 'All'.obs;

  // Therapy Types
  final therapyTypes = [
    'Physical Therapy',
    'Occupational Therapy',
    'Speech Therapy',
    'Psychotherapy',
    'Respiratory Therapy',
    'Music Therapy',
    'Art Therapy',
  ];

  // Locations
  final locations = [
    'Mumbai, Maharashtra',
    'Delhi, NCR',
    'Bangalore, Karnataka',
    'Hyderabad, Telangana',
    'Chennai, Tamil Nadu',
    'Pune, Maharashtra',
    'Kolkata, West Bengal',
  ];

  // Salary Ranges
  final salaryRanges = [
    '₹25K - ₹40K',
    '₹40K - ₹60K',
    '₹60K - ₹80K',
    '₹80K - ₹1.2L',
    '₹1.2L - ₹1.5L',
    '₹1.5L+',
  ];

  // Job Types
  final jobTypesList = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
  ];

  // Experience Levels
  final experienceLevels = [
    'Entry Level',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10+ years',
  ];

  // Common Requirements
  final commonRequirements = [
    'Relevant degree/certification',
    'State license/certification',
    '2+ years experience',
    'Good communication skills',
    'Team player',
    'Patient-centered approach',
  ];

  // Common Benefits
  final commonBenefits = [
    'Health Insurance',
    'PF & Gratuity',
    'Paid Time Off',
    'Continuing Education',
    'Flexible Schedule',
    'Performance Bonus',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
    _setupFormValidation();
  }

  void _setupFormValidation() {
    everAll([
      jobTitle,
      therapyType,
      location,
      salaryRange,
      jobType,
      experienceLevel,
      jobDescription,
      deadline,
    ], (_) {
      validateForm();
    });
  }

  void validateForm() {
    isFormValid.value = jobTitle.value.isNotEmpty &&
        therapyType.value.isNotEmpty &&
        location.value.isNotEmpty &&
        salaryRange.value.isNotEmpty &&
        jobType.value.isNotEmpty &&
        experienceLevel.value.isNotEmpty &&
        jobDescription.value.isNotEmpty &&
        deadline.value.isNotEmpty &&
        requirements.isNotEmpty;
  }

  void _loadDummyData() {
    // Load dummy posted jobs
    postedJobs.assignAll([
      PostedJob(
        id: '1',
        title: 'Senior Physical Therapist',
        therapyType: 'Physical Therapy',
        location: 'Mumbai, Maharashtra',
        salaryRange: '₹80K - ₹1.2L',
        type: 'Full-time',
        experience: '5-10 years',
        description: 'Looking for experienced physical therapist...',
        requirements: ['MPT degree', '5+ years experience', 'State license'],
        benefits: ['Health Insurance', 'PF', 'CE Allowance'],
        deadline: '2024-04-15',
        vacancies: 2,
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
        isActive: true,
        applicantsCount: 8,
        shortlistedCount: 3,
      ),
      PostedJob(
        id: '2',
        title: 'Speech Language Pathologist',
        therapyType: 'Speech Therapy',
        location: 'Bangalore, Karnataka',
        salaryRange: '₹60K - ₹80K',
        type: 'Full-time',
        experience: '3-5 years',
        description: 'Pediatric speech therapist needed...',
        requirements: ['BASLP/MASLP', 'RCI registration', 'Pediatric experience'],
        benefits: ['Health Insurance', 'Paid Leave', 'Training'],
        deadline: '2024-04-10',
        vacancies: 3,
        postedDate: DateTime.now().subtract(const Duration(days: 5)),
        isActive: true,
        applicantsCount: 12,
        shortlistedCount: 5,
      ),
      PostedJob(
        id: '3',
        title: 'Occupational Therapist',
        therapyType: 'Occupational Therapy',
        location: 'Delhi, NCR',
        salaryRange: '₹50K - ₹70K',
        type: 'Part-time',
        experience: '2-3 years',
        description: 'Part-time OT for rehabilitation center...',
        requirements: ['BOT/MOT degree', 'State registration', 'Hand therapy experience'],
        benefits: ['Flexible hours', 'PF', 'Annual Bonus'],
        deadline: '2024-03-30',
        vacancies: 1,
        postedDate: DateTime.now().subtract(const Duration(days: 10)),
        isActive: false,
        applicantsCount: 5,
        shortlistedCount: 2,
      ),
    ]);

    // Load dummy applicants
    allApplicants.assignAll([
      Applicant(
        id: '1',
        name: 'Dr. Anjali Sharma',
        email: 'anjali@email.com',
        phone: '+91 9876543210',
        experience: '6 years',
        qualification: 'MPT, Dry Needling Certified',
        resumeUrl: 'https://example.com/resume1.pdf',
        coverLetter: 'Experienced in sports injury rehabilitation...',
        appliedDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Shortlisted',
        matchScore: 85.5,
        jobId: '1',
        jobTitle: 'Senior Physical Therapist',
      ),
      Applicant(
        id: '2',
        name: 'Raj Patel',
        email: 'raj@email.com',
        phone: '+91 8765432109',
        experience: '4 years',
        qualification: 'BASLP, RCI Registered',
        resumeUrl: 'https://example.com/resume2.pdf',
        coverLetter: 'Specialized in pediatric speech therapy...',
        appliedDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Applied',
        matchScore: 72.0,
        jobId: '2',
        jobTitle: 'Speech Language Pathologist',
      ),
      Applicant(
        id: '3',
        name: 'Priya Nair',
        email: 'priya@email.com',
        phone: '+91 7654321098',
        experience: '3 years',
        qualification: 'BOT, Hand Therapy Certified',
        resumeUrl: 'https://example.com/resume3.pdf',
        coverLetter: 'Experience in neurological rehabilitation...',
        appliedDate: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Rejected',
        matchScore: 65.0,
        jobId: '1',
        jobTitle: 'Senior Physical Therapist',
      ),
      Applicant(
        id: '4',
        name: 'Amit Kumar',
        email: 'amit@email.com',
        phone: '+91 6543210987',
        experience: '8 years',
        qualification: 'MPT, Sports Medicine',
        resumeUrl: 'https://example.com/resume4.pdf',
        coverLetter: 'Former sports team therapist...',
        appliedDate: DateTime.now().subtract(const Duration(days: 4)),
        status: 'Hired',
        matchScore: 92.0,
        jobId: '1',
        jobTitle: 'Senior Physical Therapist',
      ),
    ]);

    // Initialize filtered lists
    filteredPostedJobs.assignAll(postedJobs);
    filteredApplicants.assignAll(allApplicants);
  }

  // Post Job Methods
  void addRequirement(String requirement) {
    if (requirement.isNotEmpty && !requirements.contains(requirement)) {
      requirements.add(requirement);
    }
  }

  void removeRequirement(String requirement) {
    requirements.remove(requirement);
  }

  void addBenefit(String benefit) {
    if (benefit.isNotEmpty && !benefits.contains(benefit)) {
      benefits.add(benefit);
    }
  }

  void removeBenefit(String benefit) {
    benefits.remove(benefit);
  }

  Future<void> postJob() async {
    if (!isFormValid.value) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isPostingJob.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final newJob = PostedJob(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: jobTitle.value,
      therapyType: therapyType.value,
      location: location.value,
      salaryRange: salaryRange.value,
      type: jobType.value,
      experience: experienceLevel.value,
      description: jobDescription.value,
      requirements: requirements.toList(),
      benefits: benefits.toList(),
      deadline: deadline.value,
      vacancies: vacancies.value,
      postedDate: DateTime.now(),
      isActive: true,
      applicantsCount: 0,
      shortlistedCount: 0,
    );

    postedJobs.insert(0, newJob);
    filteredPostedJobs.insert(0, newJob);

    // Clear form
    clearForm();

    Get.snackbar(
      'Success!',
      'Job posted successfully',
      backgroundColor: const Color(0xFF008080),
      colorText: Colors.white,
    );

    // Switch to Posted Jobs tab
    selectedTabIndex.value = 1;

    isPostingJob.value = false;
  }

  void clearForm() {
    jobTitle.value = '';
    therapyType.value = '';
    location.value = '';
    salaryRange.value = '';
    jobType.value = '';
    experienceLevel.value = '';
    jobDescription.value = '';
    requirements.clear();
    benefits.clear();
    deadline.value = '';
    vacancies.value = 1;
  }

  // Posted Jobs Methods
  void searchPostedJobs(String query) {
    searchPostedQuery.value = query;
    filterPostedJobs();
  }

  void filterPostedJobs() {
    var filtered = postedJobs;

    if (searchPostedQuery.value.isNotEmpty) {
      filtered.value = filtered
          .where((job) {
        final query = searchPostedQuery.value.toLowerCase();
        return job.title.toLowerCase().contains(query) ||
            job.therapyType.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
      })
          .toList();
    }


    if (filterStatus.value != 'All') {
      final isActive = filterStatus.value == 'Active';
      filtered.value = filtered.where((job) => job.isActive == isActive).toList();
    }

    filteredPostedJobs.assignAll(filtered);
  }

  void toggleJobStatus(String jobId) {
    final index = postedJobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      final job = postedJobs[index];
      postedJobs[index] = job.copyWith(isActive: !job.isActive);
      filterPostedJobs();

      Get.snackbar(
        'Status Updated',
        'Job ${job.isActive ? 'activated' : 'deactivated'}',
        backgroundColor: const Color(0xFF008080),
        colorText: Colors.white,
      );
    }
  }

  void deleteJob(String jobId) {
    Get.defaultDialog(
      title: 'Delete Job',
      middleText: 'Are you sure you want to delete this job posting?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        postedJobs.removeWhere((job) => job.id == jobId);
        filteredPostedJobs.removeWhere((job) => job.id == jobId);
        Get.back();
        Get.snackbar(
          'Deleted',
          'Job posting removed',
          backgroundColor: const Color(0xFF008080),
          colorText: Colors.white,
        );
      },
    );
  }

  // Applicants Methods
  void searchApplicants(String query) {
    searchApplicantQuery.value = query;
    filterApplicants();
  }

  void filterApplicants() {
    var filtered = allApplicants;

    if (searchApplicantQuery.value.isNotEmpty) {
      final query = searchApplicantQuery.value.toLowerCase();

      filtered.value = filtered
          .where((applicant) {
        return applicant.name.toLowerCase().contains(query) ||
            applicant.qualification.toLowerCase().contains(query) ||
            applicant.jobTitle.toLowerCase().contains(query);
      })
          .toList();
    }


    if (selectedJobFilter.value != 'All') {
      filtered.value = filtered
          .where((applicant) => applicant.jobId == selectedJobFilter.value)
          .toList();
    }

    if (filterApplicantStatus.value != 'All') {
      filtered.value = filtered
          .where((applicant) => applicant.status == filterApplicantStatus.value)
          .toList();
    }
    if (selectedJobFilter.value != 'All') {
      filtered.value = filtered
          .where((applicant) => applicant.jobId == selectedJobFilter.value)
          .toList();
    }

    if (filterApplicantStatus.value != 'All') {
      filtered.value = filtered
          .where((applicant) => applicant.status == filterApplicantStatus.value)
          .toList();
    }


    filteredApplicants.assignAll(filtered);
  }

  void updateApplicantStatus(String applicantId, String newStatus) {
    final index = allApplicants.indexWhere((app) => app.id == applicantId);
    if (index != -1) {
      final applicant = allApplicants[index];
      allApplicants[index] = applicant.copyWith(status: newStatus);
      filterApplicants();

      Get.snackbar(
        'Status Updated',
        '${applicant.name} marked as $newStatus',
        backgroundColor: const Color(0xFF008080),
        colorText: Colors.white,
      );
    }
  }

  void viewApplicantDetails(Applicant applicant) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Color(0xFF008080),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  applicant.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  applicant.qualification,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2C2C2C).withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildDetailRow('Job Applied', applicant.jobTitle),
              _buildDetailRow('Experience', applicant.experience),
              _buildDetailRow('Email', applicant.email),
              _buildDetailRow('Phone', applicant.phone),

              const SizedBox(height: 24),
              const Text(
                'Cover Letter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                applicant.coverLetter,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF2C2C2C).withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF008080)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Color(0xFF008080)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // View resume logic
                        Get.snackbar(
                          'Resume',
                          'Opening resume...',
                          backgroundColor: const Color(0xFF008080),
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008080),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'View Resume',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C2C2C).withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get stats for dashboard
  Map<String, int> getJobStats() {
    final activeJobs = postedJobs.where((job) => job.isActive).length;
    final totalApplicants = allApplicants.length;
    final shortlisted = allApplicants.where((app) => app.status == 'Shortlisted').length;
    final hired = allApplicants.where((app) => app.status == 'Hired').length;

    return {
      'activeJobs': activeJobs,
      'totalApplicants': totalApplicants,
      'shortlisted': shortlisted,
      'hired': hired,
    };
  }

  // Format date for display
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  // Get unique job titles for filter
  List<String> getJobTitlesForFilter() {
    final jobTitles = postedJobs.map((job) => job.title).toSet().toList();
    return ['All', ...jobTitles];
  }
}