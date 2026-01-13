import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:myapp/features/schedule/schedule_page_controller.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/event_model.dart';

class SchedulePageView extends GetView<SchedulePageController> {
  const SchedulePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient
          SliverAppBar(
            expandedHeight: 180,
            collapsedHeight: 80,
            pinned: true,
            floating: true,
            backgroundColor: Colors.teal.shade900,
            elevation: 0,
            title: Text(
              'Schedule',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.2,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
                    stops: [0.0, 0.7],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                    Text(
                        _getRoleDescription(),
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),


              child: IconButton(
                icon: Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              // Role selector
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Obx(() => _buildRoleSelector()),
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Upcoming Events Section
                _buildUpcomingEventsSection(),
                const SizedBox(height: 24),

                // Calendar Section
                _buildCalendarSection(),
                const SizedBox(height: 24),

                // Statistics Section
                _buildStatisticsSection(),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              _getRoleIcon(),
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Obx(() => Text(
              controller.userRole.value.replaceAll('_', ' ').toTitleCase(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )),
            const SizedBox(width: 4),
            const Icon(
              Iconsax.arrow_down_1,
              color: Colors.white,
              size: 12,
            ),
          ],
        ),
      ),
      onSelected: (value) => controller.changeUserRole(value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'patient',
          child: Row(
            children: [
              const Icon(Iconsax.user, color: Color(0xFF0D9488)),
              const SizedBox(width: 8),
              Text('Patient', style: GoogleFonts.inter()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'therapist',
          child: Row(
            children: [
              const Icon(Iconsax.health, color: Color(0xFF0D9488)),
              const SizedBox(width: 8),
              Text('Therapist', style: GoogleFonts.inter()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'therapy_center',
          child: Row(
            children: [
              const Icon(Iconsax.buildings, color: Color(0xFF0D9488)),
              const SizedBox(width: 8),
              Text('Therapy Center', style: GoogleFonts.inter()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming (Next 5 Hours)',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Iconsax.more,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.upcomingEvents.isEmpty) {
            return Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.calendar,
                      color: Color(0xFFCBD5E1),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No upcoming events',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.upcomingEvents.length,
              itemBuilder: (context, index) {
                final event = controller.upcomingEvents[index];
                return _buildEventCard(event, index);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEventCard(Event event, int index) {
    return GestureDetector(
      onTap: () => _showEventDetails(event),
      child: Container(
        width: 280,
        margin: EdgeInsets.only(
          right: 16,
          left: index == 0 ? 0 : 0,
        ),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => controller.deleteEvent(event.id),
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                icon: Iconsax.trash,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(event.color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getEventIcon(event.type),
                          color: Color(event.color),
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(event.priority)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.priority.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getPriorityColor(event.priority),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Iconsax.clock,
                        size: 14,
                        color: const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.timeRange,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(event.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendar',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Obx(() => Text(
                  '${controller.selectedDate.value.day} ${_getMonthName(controller.selectedDate.value.month)} ${controller.selectedDate.value.year}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: SfCalendar(
                headerStyle: CalendarHeaderStyle(backgroundColor: Colors.teal.shade700,textStyle: TextStyle(color: Colors.white)),
                view: CalendarView.month,
                showDatePickerButton: true,
                showNavigationArrow: true,
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ],
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    backgroundColor: Colors.transparent,
                  ),
                ),
                dataSource: _getCalendarDataSource(),
                onTap: (CalendarTapDetails details) {
                  if (details.date != null) {
                    controller.updateSelectedDate(details.date!);
                  }
                },
                cellBorderColor: Colors.transparent,
                selectionDecoration: BoxDecoration(
                  color: const Color(0xFF2DD4BF).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xFF2DD4BF),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                todayHighlightColor: const Color(0xFF0D9488),
                monthCellBuilder: (context, details) {
                  return Container(
                    decoration: BoxDecoration(
                      color: details.date == controller.selectedDate.value
                          ? const Color(0xFF2DD4BF).withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: details.date == controller.selectedDate.value
                          ? Border.all(color: const Color(0xFF2DD4BF), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        details.date.day.toString(),
                        style: GoogleFonts.inter(
                          color: details.date.month ==
                              controller.selectedDate.value.month
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFCBD5E1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Statistics',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
                series: <ColumnSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: _getChartData(),
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.value,
                    color: const Color(0xFF2DD4BF),
                    borderRadius: BorderRadius.circular(4),
                    width: 0.6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3,
          children: [
            _buildQuickActionButton(
              icon: Iconsax.calendar_add,
              text: 'Add Event',
              color: const Color(0xFF2DD4BF),
              onTap: _showAddEventDialog,
            ),
            _buildQuickActionButton(
              icon: Iconsax.note,
              text: 'Add Note',
              color: const Color(0xFF0D9488),
              onTap: () {},
            ),
            _buildQuickActionButton(
              icon: Iconsax.share,
              text: 'Share',
              color: const Color(0xFF14B8A6),
              onTap: () {},
            ),
            _buildQuickActionButton(
              icon: Iconsax.setting,
              text: 'Settings',
              color: const Color(0xFF0F766E),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  String _getRoleDescription() {
    switch (controller.userRole.value) {
      case 'patient':
        return 'View your therapy schedule and daily activities';
      case 'therapist':
        return 'Manage patient appointments and assignments';
      case 'therapy_center':
        return 'Monitor center activities and staff performance';
      default:
        return 'Manage your schedule';
    }
  }

  IconData _getRoleIcon() {
    switch (controller.userRole.value) {
      case 'patient':
        return Iconsax.user;
      case 'therapist':
        return Iconsax.health;
      case 'therapy_center':
        return Iconsax.buildings;
      default:
        return Iconsax.user;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'therapy':
        return Iconsax.health;
      case 'nutrition':
        return Iconsax.cup;
      case 'exercise':
        return Iconsax.activity;
      case 'assessment':
        return Iconsax.note_text;
      case 'review':
        return Iconsax.document_text;
      case 'interview':
        return Iconsax.briefcase;
      case 'assignment':
        return Iconsax.task_square;
      case 'meeting':
        return Iconsax.people;
      case 'performance':
        return Iconsax.chart_2;
      case 'maintenance':
        return Iconsax.setting;
      default:
        return Iconsax.calendar;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  _MeetingDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = controller.events.map((event) {
      return Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.title,
        color: Color(event.color),
        isAllDay: false,
      );
    }).toList();

    return _MeetingDataSource(appointments);
  }

  List<ChartData> _getChartData() {
    return [
      ChartData('Mon', 3),
      ChartData('Tue', 5),
      ChartData('Wed', 2),
      ChartData('Thu', 4),
      ChartData('Fri', 6),
      ChartData('Sat', 1),
      ChartData('Sun', 3),
    ];
  }

  void _showAddEventDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Event',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 24),
                _buildFormField(
                  label: 'Event Title',
                  hint: 'Enter event title',
                  icon: Iconsax.text,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'Description',
                  hint: 'Enter event description',
                  icon: Iconsax.document_text,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Start Time',
                        hint: 'Select start time',
                        icon: Iconsax.clock,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        label: 'End Time',
                        hint: 'Select end time',
                        icon: Iconsax.clock,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFFF1F5F9),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add event logic here
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFF0D9488),
                        ),
                        child: Text(
                          'Add Event',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF64748B),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEventDetails(Event event) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(event.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getEventIcon(event.type),
                      color: Color(event.color),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.type.toTitleCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(event.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.priority.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(event.priority),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                icon: Iconsax.clock,
                title: 'Time',
                value: event.timeRange,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Iconsax.calendar,
                title: 'Date',
                value:
                '${event.startTime.day} ${_getMonthName(event.startTime.month)} ${event.startTime.year}',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Iconsax.document,
                title: 'Type',
                value: event.type.toTitleCase(),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF0D9488),
                      ),
                      child: Text(
                        'Edit Event',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

// Data Source for Calendar
class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

// Chart Data Model
class ChartData {
  final String day;
  final int value;

  ChartData(this.day, this.value);
}

// Extension for String Title Case
extension StringExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}