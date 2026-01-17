import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/features/job_post/job_post_controller.dart';

import '../../models/job_post.dart';


class JobPostView extends GetView<JobPostController> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: controller.selectedTabIndex.value,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Iconsax.briefcase, size: 24, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Job Recruitment',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF004D4D),
          foregroundColor: const Color(0xFFFAFAFA),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Iconsax.add_square), text: 'Post Job'),
              Tab(icon: Icon(Iconsax.briefcase), text: 'Posted Jobs'),
              Tab(icon: Icon(Iconsax.people), text: 'Applicants'),
            ],
            indicatorColor: const Color(0xFFD4AF37),
            labelColor: const Color(0xFFFAFAFA),
            unselectedLabelColor: Colors.grey[300],
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            onTap: (index) => controller.selectedTabIndex.value = index,
          ),
        ),
        body: TabBarView(
          children: [
            // Post Job Tab
            _buildPostJobTab(),
            // Posted Jobs Tab
            _buildPostedJobsTab(),
            // Applicants Tab
            _buildApplicantsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostJobTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Job Post',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the details to post a new therapist job',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF2C2C2C).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Job Title
          _buildFormField(
            label: 'Job Title *',
            hint: 'e.g., Senior Physical Therapist',
            icon: Iconsax.briefcase,
            value: controller.jobTitle.value,
            onChanged: (value) => controller.jobTitle.value = value,
          ),

          // Therapy Type
          _buildDropdownField(
            label: 'Therapy Type *',
            value: controller.therapyType.value,
            items: controller.therapyTypes,
            onChanged: (value) => controller.therapyType.value = value ?? '',
            icon: Iconsax.health,
          ),

          // Location
          _buildDropdownField(
            label: 'Location *',
            value: controller.location.value,
            items: controller.locations,
            onChanged: (value) => controller.location.value = value ?? '',
            icon: Iconsax.location,
          ),

          // Salary Range
          _buildDropdownField(
            label: 'Salary Range *',
            value: controller.salaryRange.value,
            items: controller.salaryRanges,
            onChanged: (value) => controller.salaryRange.value = value ?? '',
            icon: Iconsax.money,
          ),

          // Job Type
          _buildDropdownField(
            label: 'Job Type *',
            value: controller.jobType.value,
            items: controller.jobTypesList,
            onChanged: (value) => controller.jobType.value = value ?? '',
            icon: Iconsax.clock,
          ),

          // Experience Level
          _buildDropdownField(
            label: 'Experience Level *',
            value: controller.experienceLevel.value,
            items: controller.experienceLevels,
            onChanged: (value) => controller.experienceLevel.value = value ?? '',
            icon: Iconsax.cpu,
          ),

          // Vacancies
          _buildNumberField(
            label: 'Number of Vacancies',
            value: controller.vacancies.value,
            onChanged: (value) => controller.vacancies.value = value,
          ),

          // Deadline
          _buildFormField(
            label: 'Application Deadline *',
            hint: 'YYYY-MM-DD',
            icon: Iconsax.calendar,
            value: controller.deadline.value,
            onChanged: (value) => controller.deadline.value = value,
          ),

          // Job Description
          _buildTextArea(
            label: 'Job Description *',
            hint: 'Describe the job responsibilities and expectations...',
            value: controller.jobDescription.value,
            onChanged: (value) => controller.jobDescription.value = value,
          ),

          // Requirements
          _buildMultiSelectField(
            label: 'Requirements *',
            hint: 'Add requirements',
            items: controller.commonRequirements,
            selectedItems: controller.requirements,
            onAdd: (item) => controller.addRequirement(item),
            onRemove: (item) => controller.removeRequirement(item),
            icon: Iconsax.tick_circle,
          ),

          // Benefits
          _buildMultiSelectField(
            label: 'Benefits (Optional)',
            hint: 'Add benefits',
            items: controller.commonBenefits,
            selectedItems: controller.benefits,
            onAdd: (item) => controller.addBenefit(item),
            onRemove: (item) => controller.removeBenefit(item),
            icon: Iconsax.gift,
          ),

          const SizedBox(height: 32),

          // Submit Button
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isFormValid.value && !controller.isPostingJob.value
                  ? () => controller.postJob()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              icon: controller.isPostingJob.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Iconsax.send_2, size: 20),
              label: Text(
                controller.isPostingJob.value ? 'Posting...' : 'Post Job',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPostedJobsTab() {
    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Search posted jobs...',
                leading: const Icon(Iconsax.search_normal, color: Color(0xFF004D4D)),
                elevation: const MaterialStatePropertyAll(0),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  const Color(0xFFE0F7FA).withOpacity(0.5),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: controller.searchPostedJobs,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Obx(() => DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: controller.filterStatus.value,
                          isExpanded: true,
                          icon: const Icon(Iconsax.arrow_down, size: 16),
                          items: ['All', 'Active', 'Inactive']
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            controller.filterStatus.value = value ?? 'All';
                            controller.filterPostedJobs();
                          },
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Stats
        Obx(() {
          final stats = controller.getJobStats();
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFFE0F7FA).withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Active Jobs', stats['activeJobs']?.toString() ?? '0', Iconsax.briefcase),
                _buildStatItem('Applicants', stats['totalApplicants']?.toString() ?? '0', Iconsax.people),
                _buildStatItem('Shortlisted', stats['shortlisted']?.toString() ?? '0', Iconsax.tick_circle),
              ],
            ),
          );
        }),

        // Jobs List
        Expanded(
          child: Obx(() {
            if (controller.filteredPostedJobs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.briefcase,
                      size: 72,
                      color: const Color(0xFF2C2C2C).withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No jobs posted yet',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Post your first job from the "Post Job" tab',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF2C2C2C).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => controller.filterPostedJobs(),
              color: const Color(0xFF008080),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredPostedJobs.length,
                itemBuilder: (context, index) {
                  final job = controller.filteredPostedJobs[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPostedJobCard(job),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildApplicantsTab() {
    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Search applicants...',
                leading: const Icon(Iconsax.search_normal, color: Color(0xFF004D4D)),
                elevation: const MaterialStatePropertyAll(0),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  const Color(0xFFE0F7FA).withOpacity(0.5),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: controller.searchApplicants,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: controller.selectedJobFilter.value,
                          isExpanded: true,
                          icon: const Icon(Iconsax.arrow_down, size: 16),
                          items: controller.getJobTitlesForFilter()
                              .map((job) => DropdownMenuItem(
                            value: job,
                            child: Text(
                              job,
                              style: GoogleFonts.poppins(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            controller.selectedJobFilter.value = value ?? 'All';
                            controller.filterApplicants();
                          },
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
                    ),
                    child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: controller.filterApplicantStatus.value,
                        icon: const Icon(Iconsax.arrow_down, size: 16),
                        items: ['All', 'Applied', 'Shortlisted', 'Rejected', 'Hired']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          controller.filterApplicantStatus.value = value ?? 'All';
                          controller.filterApplicants();
                        },
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Applicants List
        Expanded(
          child: Obx(() {
            if (controller.filteredApplicants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.people,
                      size: 72,
                      color: const Color(0xFF2C2C2C).withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No applicants yet',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Applicants will appear here once they apply',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF2C2C2C).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => controller.filterApplicants(),
              color: const Color(0xFF008080),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredApplicants.length,
                itemBuilder: (context, index) {
                  final applicant = controller.filteredApplicants[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildApplicantCard(applicant),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF004D4D)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF008080).withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF008080)),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF004D4D)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: value.isNotEmpty ? value : null,
                    isExpanded: true,
                    hint: Text(
                      'Select $label',
                      style: TextStyle(color: const Color(0xFF2C2C2C).withOpacity(0.5)),
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(color: const Color(0xFF2C2C2C)),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Iconsax.minus_cirlce, color: Color(0xFF004D4D)),
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
              ),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.add_circle, color: Color(0xFF004D4D)),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF008080).withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF008080)),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required String hint,
    required List<String> items,
    required RxList<String> selectedItems,
    required Function(String) onAdd,
    required Function(String) onRemove,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),

        // Selected Items
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Iconsax.close_circle, size: 16),
              onDeleted: () => onRemove(item),
              backgroundColor: const Color(0xFFE0F7FA).withOpacity(0.5),
            );
          }).toList(),
        )),

        const SizedBox(height: 12),

        // Add New Item
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: Icon(icon, color: const Color(0xFF004D4D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFF008080).withOpacity(0.3)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onAdd(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Iconsax.add, color: Color(0xFF004D4D)),
              onPressed: () {
                // Can add from common items
                if (items.isNotEmpty && !selectedItems.contains(items.first)) {
                  onAdd(items.first);
                }
              },
              tooltip: 'Add common item',
            ),
          ],
        ),

        // Common Items
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items.map((item) {
              return Obx(() {
                final isSelected = selectedItems.contains(item);
                return FilterChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onAdd(item);
                    } else {
                      onRemove(item);
                    }
                  },
                  selectedColor: const Color(0xFF008080),
                  checkmarkColor: Colors.white,
                );
              });
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPostedJobCard(PostedJob job) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Iconsax.briefcase,
                      color: Color(0xFF008080),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                      Text(
                        '${job.therapyType} • ${job.location}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,

                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: job.isActive
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFF9E9E9E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: job.isActive
                          ? const Color(0xFF4CAF50).withOpacity(0.3)
                          : const Color(0xFF9E9E9E).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    job.isActive ? 'Active' : 'Inactive',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: job.isActive ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Details
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Iconsax.money,
                  text: job.salaryRange,
                  color: const Color(0xFF4CAF50),
                ),
                _buildDetailChip(
                  icon: Iconsax.clock,
                  text: job.type,
                  color: const Color(0xFFD4AF37),
                ),
                _buildDetailChip(
                  icon: Iconsax.cpu,
                  text: job.experience,
                  color: const Color(0xFF004D4D),
                ),
                _buildDetailChip(
                  icon: Iconsax.people,
                  text: '${job.vacancies} vacancies',
                  color: const Color(0xFF008080),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Stats
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posted ${controller.formatDate(job.postedDate)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF008080),
                          ),
                        ),
                        Text(
                          'Deadline: ${job.deadline}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        job.applicantsCount.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF004D4D),
                        ),
                      ),
                      Text(
                        'Applicants',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFF2C2C2C).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        job.shortlistedCount.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        'Shortlisted',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFF2C2C2C).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.toggleJobStatus(job.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF008080),
                      side: const BorderSide(color: Color(0xFF008080)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      job.isActive ? Iconsax.pause_circle : Iconsax.play_circle,
                      size: 16,
                    ),
                    label: Text(
                      job.isActive ? 'Deactivate' : 'Activate',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.selectedTabIndex.value = 2,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D4D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Iconsax.people, size: 16),
                    label: Text(
                      'View Applicants',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Iconsax.trash, color: Color(0xFFE53935)),
                  onPressed: () => controller.deleteJob(job.id),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantCard(Applicant applicant) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Iconsax.personalcard,
                      color: Color(0xFF008080),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      Text(
                        applicant.qualification,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF2C2C2C).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(int.parse(applicant.statusColor.substring(1, 7), radix: 16) + 0xFF000000)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(int.parse(applicant.statusColor.substring(1, 7), radix: 16) + 0xFF000000)
                          .withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        applicant.statusIcon,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        applicant.status,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(int.parse(applicant.statusColor.substring(1, 7), radix: 16) + 0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Details
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Iconsax.briefcase,
                  text: applicant.jobTitle,
                  color: const Color(0xFF004D4D),
                ),
                _buildDetailChip(
                  icon: Iconsax.cpu,
                  text: applicant.experience,
                  color: const Color(0xFFD4AF37),
                ),
                _buildDetailChip(
                  icon: Iconsax.document_text,
                  text: '${applicant.matchScore}% match',
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Applied ${controller.formatDate(applicant.appliedDate)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF008080),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Iconsax.sms, size: 12, color: const Color(0xFF2C2C2C).withOpacity(0.6)),
                            const SizedBox(width: 4),
                            Text(
                              applicant.email,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFF2C2C2C).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Iconsax.more, color: Color(0xFF2C2C2C)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('View Details'),
                        onTap: () => controller.viewApplicantDetails(applicant),
                      ),
                      PopupMenuItem(
                        child: const Text('Mark as Shortlisted'),
                        onTap: () => controller.updateApplicantStatus(applicant.id, 'Shortlisted'),
                      ),
                      PopupMenuItem(
                        child: const Text('Mark as Hired'),
                        onTap: () => controller.updateApplicantStatus(applicant.id, 'Hired'),
                      ),
                      PopupMenuItem(
                        child: const Text('Reject'),
                        onTap: () => controller.updateApplicantStatus(applicant.id, 'Rejected'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],)
        );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF008080)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: const Color(0xFF2C2C2C).withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}