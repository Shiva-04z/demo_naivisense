import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/job_post.dart';
import '../../core/globals/dummy_data.dart';

class MyJobsController extends GetxController {
  // Observables
  final selectedTabIndex = 0.obs;
  final searchQuery = ''.obs;
  final filterTherapyType = 'All'.obs;
  final filterLocation = 'All'.obs;
  final filterExperience = 'All'.obs;
  final filterJobType = 'All'.obs;
  final filterSalaryRange = 'All'.obs;
  final isLoading = false.obs;
  final showFilters = false.obs;
  final RxString selectedSortBy = 'Relevance'.obs;

  // Job lists
  final RxList<JobPost> allJobs = <JobPost>[].obs;
  final RxList<JobPost> appliedJobs = <JobPost>[].obs;

  // Getter for filtered jobs
  List<JobPost> get filteredJobs {
    List<JobPost> jobs = selectedTabIndex.value == 0 ? allJobs : appliedJobs;

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      jobs = jobs.where((job) {
        return job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.organization.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.therapyType.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.location.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.specialization.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Apply therapy type filter
    if (filterTherapyType.value != 'All') {
      jobs = jobs.where((job) => job.therapyType == filterTherapyType.value).toList();
    }

    // Apply location filter
    if (filterLocation.value != 'All') {
      jobs = jobs.where((job) => job.location == filterLocation.value).toList();
    }

    // Apply experience filter
    if (filterExperience.value != 'All') {
      jobs = jobs.where((job) => job.experience == filterExperience.value).toList();
    }

    // Apply job type filter
    if (filterJobType.value != 'All') {
      jobs = jobs.where((job) => job.type == filterJobType.value).toList();
    }

    // Apply salary range filter
    if (filterSalaryRange.value != 'All') {
      final salaryRange = DummyData.getSalaryRanges()
          .firstWhere((range) => range['label'] == filterSalaryRange.value);
      final min = salaryRange['min'] as int;
      final max = salaryRange['max'] as int;
      jobs = jobs.where((job) => job.isSalaryInRange(min, max)).toList();
    }

    // Apply sorting
    jobs = _sortJobs(jobs);

    return jobs;
  }

  // Sort jobs based on selected criteria
  List<JobPost> _sortJobs(List<JobPost> jobs) {
    switch (selectedSortBy.value) {
      case 'Salary: High to Low':
        jobs.sort((a, b) => b.averageSalary.compareTo(a.averageSalary));
        break;
      case 'Salary: Low to High':
        jobs.sort((a, b) => a.averageSalary.compareTo(b.averageSalary));
        break;
      case 'Experience: High to Low':
        final expOrder = {'Senior Level': 4, 'Mid Level': 3, 'Entry Level': 2, 'Specialist': 5};
        jobs.sort((a, b) =>
            (expOrder[b.experience] ?? 1).compareTo(expOrder[a.experience] ?? 1));
        break;
      case 'Newest First':
      // Sort by posted date (assuming newer jobs have lower days ago)
        jobs.sort((a, b) {
          final aDays = _extractDays(a.postedDate);
          final bDays = _extractDays(b.postedDate);
          return aDays.compareTo(bDays);
        });
        break;
      case 'Deadline':
      // Sort by deadline (closest first)
        jobs.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default: // Relevance
      // Keep original order for now
        break;
    }
    return jobs;
  }

  int _extractDays(String postedDate) {
    if (postedDate == 'Yesterday') return 1;
    final daysMatch = RegExp(r'(\d+)').firstMatch(postedDate);
    return daysMatch != null ? int.parse(daysMatch.group(1)!) : 999;
  }

  // Get unique filter options
  List<String> get therapyTypes => DummyData.getAllTherapyTypes();
  List<String> get locations => DummyData.getAllLocations();
  List<String> get experienceLevels => DummyData.getAllExperienceLevels();
  List<String> get jobTypes => DummyData.getAllJobTypes();
  List<String> get salaryRanges => DummyData.getSalaryRanges().map((r) => r['label'] as String).toList();
  List<String> get sortOptions => ['Relevance', 'Salary: High to Low', 'Salary: Low to High', 'Experience: High to Low', 'Newest First', 'Deadline'];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Load jobs from dummy data (30 total, 5 already applied)
    allJobs.assignAll(DummyData.generateTherapistJobs(count: 30, appliedCount: 5));

    // Separate applied jobs
    appliedJobs.assignAll(allJobs.where((job) => job.isApplied).toList());

    // Sort applied jobs by application date (newest first)
    appliedJobs.sort((a, b) => b.appliedDate!.compareTo(a.appliedDate!));

    isLoading.value = false;
  }

  void applyToJob(String jobId) {
    final jobIndex = allJobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1 && !allJobs[jobIndex].isApplied) {
      // Update the job to applied
      final updatedJob = allJobs[jobIndex].copyWith(
        isApplied: true,
        appliedDate: DateTime.now(),
      );
      allJobs[jobIndex] = updatedJob;

      // Add to applied jobs list
      if (!appliedJobs.any((job) => job.id == jobId)) {
        appliedJobs.add(updatedJob);
      }

      // Sort applied jobs by applied date (newest first)
      appliedJobs.sort((a, b) => b.appliedDate!.compareTo(a.appliedDate!));

      // Show success message
      Get.snackbar(
        '✅ Application Submitted',
        'Successfully applied for ${updatedJob.title} at ${updatedJob.organization}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF008080),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );

      update();
    } else if (allJobs[jobIndex].isApplied) {
      Get.snackbar(
        '⚠️ Already Applied',
        'You have already applied for this position',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void withdrawApplication(String jobId) {
    final jobIndex = allJobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1 && allJobs[jobIndex].isApplied) {
      // Update the job to not applied
      allJobs[jobIndex] = allJobs[jobIndex].copyWith(isApplied: false);

      // Remove from applied jobs
      appliedJobs.removeWhere((job) => job.id == jobId);

      Get.snackbar(
        '↩️ Application Withdrawn',
        'Application withdrawn successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF004D4D),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
      );

      update();
    }
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void clearAllFilters() {
    filterTherapyType.value = 'All';
    filterLocation.value = 'All';
    filterExperience.value = 'All';
    filterJobType.value = 'All';
    filterSalaryRange.value = 'All';
    searchQuery.value = '';
    selectedSortBy.value = 'Relevance';
    showFilters.value = false;
    update();
  }

  void searchJobs(String query) {
    searchQuery.value = query;
  }

  void setSelectedTab(int index) {
    selectedTabIndex.value = index;
  }

  bool isJobApplied(String jobId) {
    return appliedJobs.any((job) => job.id == jobId);
  }

  // Get time ago for posted date
  String getTimeAgo(String postedDate) {
    if (postedDate.contains('day')) {
      final days = int.tryParse(postedDate.split(' ')[0]) ?? 0;
      if (days == 1) return 'Yesterday';
      return postedDate;
    }
    if (postedDate.contains('week')) {
      final weeks = int.tryParse(postedDate.split(' ')[0]) ?? 0;
      if (weeks == 1) return 'Last week';
      return postedDate;
    }
    return postedDate;
  }

  // Format applied date to human readable
  String formatAppliedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      }
      return '${difference.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  // Get statistics for dashboard
  Map<String, int> getJobStatistics() {
    return {
      'totalJobs': allJobs.length,
      'appliedJobs': appliedJobs.length,
      'urgentJobs': allJobs.where((job) => job.isUrgent && !job.isExpired).length,
      'remoteJobs': allJobs.where((job) => job.isRemote).length,
      'expiredJobs': allJobs.where((job) => job.isExpired).length,
    };
  }

  // Get popular therapy types based on job count
  Map<String, int> getPopularTherapyTypes() {
    final Map<String, int> therapyCounts = {};
    for (var job in allJobs) {
      therapyCounts[job.therapyType] = (therapyCounts[job.therapyType] ?? 0) + 1;
    }
    return therapyCounts;
  }

  // Get salary distribution
  Map<String, int> getSalaryDistribution() {
    final distribution = {
      'Under ₹30K': 0,
      '₹30K - ₹50K': 0,
      '₹50K - ₹80K': 0,
      '₹80K - ₹1.2L': 0,
      'Above ₹1.2L': 0,
    };

    for (var job in allJobs) {
      final avgSalary = job.averageSalary;
      if (avgSalary < 30000) {
        distribution['Under ₹30K'] = distribution['Under ₹30K']! + 1;
      } else if (avgSalary <= 50000) {
        distribution['₹30K - ₹50K'] = distribution['₹30K - ₹50K']! + 1;
      } else if (avgSalary <= 80000) {
        distribution['₹50K - ₹80K'] = distribution['₹50K - ₹80K']! + 1;
      } else if (avgSalary <= 120000) {
        distribution['₹80K - ₹1.2L'] = distribution['₹80K - ₹1.2L']! + 1;
      } else {
        distribution['Above ₹1.2L'] = distribution['Above ₹1.2L']! + 1;
      }
    }

    return distribution;
  }

  // Mark job as saved/favorite (optional feature)
  final RxList<String> savedJobs = <String>[].obs;

  void toggleSaveJob(String jobId) {
    if (savedJobs.contains(jobId)) {
      savedJobs.remove(jobId);
      Get.snackbar(
        '💔 Removed from Saved',
        'Job removed from your saved list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2C2C2C),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } else {
      savedJobs.add(jobId);
      Get.snackbar(
        '💖 Job Saved',
        'Added to your saved jobs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF008080),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }
  }

  bool isJobSaved(String jobId) {
    return savedJobs.contains(jobId);
  }

  // Get saved jobs
  List<JobPost> get savedJobsList {
    return allJobs.where((job) => savedJobs.contains(job.id)).toList();
  }

  // Share job functionality
  void shareJob(JobPost job) {
    final shareText = '''
🏥 ${job.title}
📍 ${job.organization}
🗺️ ${job.location}
💰 ${job.salaryRange} per month
🎯 ${job.therapyType} - ${job.specialization}
📅 Apply by: ${job.deadline}
    ''';

    // In a real app, you would use share_plus package
    Get.snackbar(
      '📤 Share Job',
      'Job details copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF004D4D),
      colorText: Colors.white,
    );

    // Copy to clipboard (you'll need clipboard package)
    // Clipboard.setData(ClipboardData(text: shareText));
  }

  // Refresh jobs
  Future<void> refreshJobs() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    // Reload data
    await loadInitialData();

    Get.snackbar(
      '🔄 Refreshed',
      'Job list updated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF008080),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );

    isLoading.value = false;
  }

  // Get recommended jobs based on applied jobs
  List<JobPost> getRecommendedJobs() {
    if (appliedJobs.isEmpty) {
      // If no applied jobs, return featured jobs
      return DummyData.getFeaturedJobs();
    }

    // Get therapy types from applied jobs
    final appliedTherapies = appliedJobs.map((job) => job.therapyType).toSet();

    // Find similar jobs
    final recommended = <JobPost>[];
    for (var therapy in appliedTherapies) {
      final similarJobs = allJobs
          .where((job) =>
      job.therapyType == therapy &&
          !job.isApplied &&
          !job.isExpired)
          .take(2)
          .toList();
      recommended.addAll(similarJobs);
    }

    // If not enough recommendations, add some featured jobs
    if (recommended.length < 4) {
      recommended.addAll(DummyData.getFeaturedJobs().take(4 - recommended.length));
    }

    return recommended.toSet().toList(); // Remove duplicates
  }
}