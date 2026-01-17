import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/features/my_jobs/my_jobs_controller.dart';
import '../../models/job_post.dart';



class MyJobsView extends GetView<MyJobsController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: controller.selectedTabIndex.value,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Iconsax.briefcase, size: 24, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Therapist Jobs',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF004D4D),
          foregroundColor: const Color(0xFFFAFAFA),
          actions: [
            IconButton(
              icon: Icon(Iconsax.refresh, size: 22),
              onPressed: controller.refreshJobs,
              tooltip: 'Refresh',
            ),
            IconButton(
              icon: Icon(Iconsax.filter_search, size: 22),
              onPressed: controller.toggleFilters,
              tooltip: 'Filters',
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Iconsax.briefcase), text: 'All Jobs'),
              Tab(icon: Icon(Iconsax.document_text), text: 'Applied'),
            ],
            indicatorColor: const Color(0xFFD4AF37),
            labelColor: const Color(0xFFFAFAFA),
            unselectedLabelColor: Colors.grey[300],
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            onTap: controller.setSelectedTab,
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            // Stats Bar (Optional)
            _buildStatsBar(),
            // Filter Panel
            Obx(() => _buildFilterPanel()),
            // Main Content
            Expanded(
              child: TabBarView(
                children: [
                  // All Jobs Tab
                  _buildAllJobsTab(),
                  // Applied Jobs Tab
                  _buildAppliedJobsTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(() {
          if (controller.selectedTabIndex.value == 0) {
            return FloatingActionButton.extended(
              onPressed: () => _showAdvancedFilters(context),
              backgroundColor: const Color(0xFF008080),
              foregroundColor: Colors.white,
              icon: const Icon(Iconsax.filter),
              label: Text('Filters', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SearchBar(
          hintText: 'Search therapist jobs...',
          leading: const Icon(Iconsax.search_normal, color: Color(0xFF004D4D)),
          trailing: [
            Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                return IconButton(
                  icon: Icon(Iconsax.close_circle, color: const Color(0xFF004D4D).withOpacity(0.6)),
                  onPressed: () => controller.searchQuery.value = '',
                );
              }
              return const SizedBox();
            }),
          ],
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: const Color(0xFF008080).withOpacity(0.3)),
            ),
          ),
          backgroundColor: const MaterialStatePropertyAll(Colors.white),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: controller.searchJobs,
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Obx(() {
      final stats = controller.getJobStatistics();
      return FadeIn(
        duration: const Duration(milliseconds: 400),
        child: Container(
          color: const Color(0xFFE0F7FA).withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Iconsax.briefcase,
                value: stats['totalJobs'].toString(),
                label: 'Total Jobs',
                color: const Color(0xFF008080),
              ),
              _buildStatItem(
                icon: Iconsax.document_text,
                value: stats['appliedJobs'].toString(),
                label: 'Applied',
                color: const Color(0xFF4CAF50),
              ),
              _buildStatItem(
                icon: Iconsax.clock,
                value: stats['urgentJobs'].toString(),
                label: 'Urgent',
                color: const Color(0xFFE53935),
              ),
              _buildStatItem(
                icon: Iconsax.home,
                value: stats['remoteJobs'].toString(),
                label: 'Remote',
                color: const Color(0xFFD4AF37),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
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

  Widget _buildFilterPanel() {
    return Obx(() {
      if (!controller.showFilters.value) return const SizedBox();

      return FadeInDown(
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Therapy Type Filter
              _buildFilterChips(
                title: 'Therapy Type',
                selectedValue: controller.filterTherapyType.value,
                options: controller.therapyTypes,
                onChanged: (value) => controller.filterTherapyType.value = value,
              ),
              const SizedBox(height: 12),
              // Sort Options
              _buildSortDropdown(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterChips({
    required String title,
    required String selectedValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onChanged(option),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF008080),
              side: BorderSide(
                color: isSelected ? const Color(0xFF008080) : const Color(0xFFE0E0E0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedSortBy.value,
          isExpanded: true,
          icon: const Icon(Iconsax.arrow_down, size: 16, color: Color(0xFF004D4D)),
          items: controller.sortOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedSortBy.value = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildAllJobsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF008080),
          ),
        );
      }

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Job Count and Sort
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: FadeIn(
                duration: const Duration(milliseconds: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.filteredJobs.length} therapist jobs',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF004D4D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.sort,
                        size: 20,
                        color: const Color(0xFF004D4D),
                      ),
                      onPressed: () => _showSortModal(Get.context!),
                      tooltip: 'Sort',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recommended Section (if any)
          if (controller.getRecommendedJobs().isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
              sliver: SliverToBoxAdapter(
                child: FadeIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended for you',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: controller.getRecommendedJobs().map((job) {
                            return Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 12),
                              child: _buildRecommendedCard(job),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Jobs List
          if (controller.filteredJobs.isEmpty)
            SliverFillRemaining(
              child: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Center(
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
                        controller.searchQuery.value.isEmpty
                            ? 'No therapist jobs available'
                            : 'No jobs found for "${controller.searchQuery.value}"',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF2C2C2C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (controller.searchQuery.value.isNotEmpty)
                        TextButton(
                          onPressed: controller.clearAllFilters,
                          child: Text(
                            'Clear search & filters',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF008080),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final job = controller.filteredJobs[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildJobCard(job, false),
                      ),
                    );
                  },
                  childCount: controller.filteredJobs.length,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildAppliedJobsTab() {
    return Obx(() {
      if (controller.appliedJobs.isEmpty) {
        return FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.document_text,
                  size: 72,
                  color: const Color(0xFF2C2C2C).withOpacity(0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'No applications yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apply to therapist jobs from the "All Jobs" tab',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF2C2C2C).withOpacity(0.6),

                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.setSelectedTab(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008080),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Iconsax.briefcase, size: 18),
                  label: Text(
                    'Browse Jobs',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Applied Jobs Count
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: FadeIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.appliedJobs.length} applications',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF004D4D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (controller.appliedJobs.any((job) => job.isUrgent))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE53935).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              size: 12,
                              color: const Color(0xFFE53935),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Urgent',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFFE53935),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Application Status Stats
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: FadeIn(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF008080).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildApplicationStat(
                        count: controller.appliedJobs
                            .where((job) => !job.isExpired)
                            .length,
                        label: 'Active',
                        color: const Color(0xFF4CAF50),
                      ),
                      _buildApplicationStat(
                        count: controller.appliedJobs
                            .where((job) => job.isExpired)
                            .length,
                        label: 'Expired',
                        color: const Color(0xFF9E9E9E),
                      ),
                      _buildApplicationStat(
                        count: controller.appliedJobs
                            .where((job) => job.appliedDate != null &&
                            DateTime.now()
                                .difference(job.appliedDate!)
                                .inDays < 3)
                            .length,
                        label: 'Recent',
                        color: const Color(0xFFD4AF37),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Applied Jobs List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final job = controller.appliedJobs[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildJobCard(job, true),
                    ),
                  );
                },
                childCount: controller.appliedJobs.length,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildApplicationStat({
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: const Color(0xFF2C2C2C).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard(JobPost job, bool isApplied) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showJobDetails(job),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and save button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Therapy Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(int.parse(job.therapyColor.substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        job.therapyIcon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                job.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2C2C2C),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            PopupMenuButton(
                              icon: Icon(
                                Iconsax.more,
                                size: 20,
                                color: const Color(0xFF2C2C2C).withOpacity(0.6),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.save_2,
                                        size: 18,
                                        color: const Color(0xFF2C2C2C),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        controller.isJobSaved(job.id)
                                            ? 'Remove from Saved'
                                            : 'Save Job',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: const Color(0xFF2C2C2C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => controller.toggleSaveJob(job.id),
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.share,
                                        size: 18,
                                        color: const Color(0xFF2C2C2C),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Share Job',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: const Color(0xFF2C2C2C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => controller.shareJob(job),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.organization,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF2C2C2C).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Job details row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    icon: Iconsax.location,
                    text: job.location,
                    color: const Color(0xFF004D4D),
                  ),
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
                    text: job.therapyType,
                    color: Color(int.parse(job.therapyColor.substring(1, 7), radix: 16) + 0xFF000000),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Requirements preview
              if (job.requirements.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requirements:',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.requirements.take(2).join(', '),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF2C2C2C).withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Footer with deadline and action buttons
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
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar,
                                size: 12,
                                color: const Color(0xFF008080),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Posted ${job.postedDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF008080),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Iconsax.timer,
                                size: 12,
                                color: job.isExpired
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFFD4AF37),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                job.isExpired ? 'Expired' : job.timeRemaining,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: job.isExpired
                                      ? const Color(0xFFE53935)
                                      : const Color(0xFFD4AF37),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isApplied)
                      OutlinedButton(
                        onPressed: () => controller.withdrawApplication(job.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE53935),
                          side: const BorderSide(color: Color(0xFFE53935)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                        ),
                        child: Text(
                          'Withdraw',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: job.isExpired
                            ? null
                            : () => controller.applyToJob(job.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: job.isExpired
                              ? Colors.grey[300]
                              : const Color(0xFF008080),
                          foregroundColor: job.isExpired
                              ? Colors.grey[600]
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          job.isExpired ? 'Expired' : 'Apply Now',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Applied status badge
              if (isApplied && job.appliedDate != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF008080).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.tick_circle,
                          size: 12,
                          color: const Color(0xFF008080),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Applied ${controller.formatAppliedDate(job.appliedDate!)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF008080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Urgent badge
              if (job.isUrgent)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE53935).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 12,
                          color: const Color(0xFFE53935),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Urgent Hiring',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFFE53935),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(JobPost job) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(int.parse(job.therapyColor.substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      job.therapyIcon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C2C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        job.organization,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF2C2C2C).withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: 12,
                  color: const Color(0xFF004D4D),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF004D4D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Iconsax.money,
                  size: 12,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 4),
                Text(
                  job.salaryRange,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.applyToJob(job.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 32),
              ),
              child: Text(
                'Apply Now',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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
        ],
      ),
    );
  }

  // Modal Dialogs
  void _showAdvancedFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Advanced Filters',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.close_circle),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Therapy Type Filter
                  _buildFilterSection(
                    title: 'Therapy Type',
                    selectedValue: controller.filterTherapyType.value,
                    options: controller.therapyTypes,
                    onChanged: (value) {
                      controller.filterTherapyType.value = value;
                      setState(() {});
                    },
                  ),

                  // Location Filter
                  _buildFilterSection(
                    title: 'Location',
                    selectedValue: controller.filterLocation.value,
                    options: controller.locations,
                    onChanged: (value) {
                      controller.filterLocation.value = value;
                      setState(() {});
                    },
                  ),

                  // Experience Filter
                  _buildFilterSection(
                    title: 'Experience Level',
                    selectedValue: controller.filterExperience.value,
                    options: controller.experienceLevels,
                    onChanged: (value) {
                      controller.filterExperience.value = value;
                      setState(() {});
                    },
                  ),

                  // Salary Range Filter
                  _buildSalaryFilterSection(),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.clearAllFilters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4AF37),
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            controller.showFilters.value = false;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008080),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Apply Filters',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required String selectedValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF008080)
                      : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF008080)
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSalaryFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Range (per month)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.salaryRanges.map((range) {
            final isSelected = range == controller.filterSalaryRange.value;
            return GestureDetector(
              onTap: () => controller.filterSalaryRange.value = range,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF008080)
                      : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF008080)
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                child: Text(
                  range,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort Jobs By',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 16),
              ...controller.sortOptions.map((option) {
                return ListTile(
                  leading: Icon(
                    controller.selectedSortBy.value == option
                        ? Iconsax.tick_circle
                        : Icons.circle,
                    color: controller.selectedSortBy.value == option
                        ? const Color(0xFF008080)
                        : const Color(0xFFE0E0E0),
                  ),
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  onTap: () {
                    controller.selectedSortBy.value = option;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showJobDetails(JobPost job) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(int.parse(job.therapyColor.substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          job.therapyIcon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.isJobSaved(job.id)
                                ? Iconsax.save_21
                                : Iconsax.save_2,
                            color: controller.isJobSaved(job.id)
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF2C2C2C).withOpacity(0.6),
                          ),
                          onPressed: () => controller.toggleSaveJob(job.id),
                        ),
                        IconButton(
                          icon: Icon(Iconsax.share,
                              color: const Color(0xFF2C2C2C).withOpacity(0.6)),
                          onPressed: () => controller.shareJob(job),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  job.title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job.organization,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF2C2C2C).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),

                // Job Details Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 8,
                  children: [
                    _buildDetailItem(
                      icon: Iconsax.location,
                      title: 'Location',
                      value: job.location,
                    ),
                    _buildDetailItem(
                      icon: Iconsax.money,
                      title: 'Salary',
                      value: '${job.salaryRange}/month',
                    ),
                    _buildDetailItem(
                      icon: Iconsax.clock,
                      title: 'Job Type',
                      value: job.type,
                    ),
                    _buildDetailItem(
                      icon: Iconsax.cpu,
                      title: 'Therapy Type',
                      value: job.therapyType,
                    ),
                    _buildDetailItem(
                      icon: Iconsax.calendar,
                      title: 'Experience',
                      value: job.experience,
                    ),
                    _buildDetailItem(
                      icon: Iconsax.timer,
                      title: 'Deadline',
                      value: job.deadline,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  'Job Description',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF2C2C2C).withOpacity(0.7),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Requirements
                Text(
                  'Requirements',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                ...job.requirements.map((req) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Iconsax.tick_circle, size: 16, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          req,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF2C2C2C).withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),

                const SizedBox(height: 24),

                // Benefits
                if (job.benefits.isNotEmpty) ...[
                  Text(
                    'Benefits',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.benefits.map((benefit) => Chip(
                      label: Text(
                        benefit,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      backgroundColor: const Color(0xFFE0F7FA).withOpacity(0.5),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: job.isExpired ? null : () {
                      if (!controller.isJobApplied(job.id)) {
                        controller.applyToJob(job.id);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isJobApplied(job.id)
                          ? const Color(0xFF4CAF50)
                          : job.isExpired
                          ? Colors.grey[300]
                          : const Color(0xFF008080),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: Icon(
                      controller.isJobApplied(job.id)
                          ? Iconsax.tick_circle
                          : job.isExpired
                          ? Iconsax.close_circle
                          : Iconsax.send_2,
                    ),
                    label: Text(
                      controller.isJobApplied(job.id)
                          ? 'Already Applied'
                          : job.isExpired
                          ? 'Job Expired'
                          : 'Apply Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF008080)),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFF2C2C2C).withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }
}