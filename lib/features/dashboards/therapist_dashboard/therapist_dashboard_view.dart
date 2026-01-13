import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'therapist_dashboard_controller.dart';
import 'package:google_fonts/google_fonts.dart';
// Note: For Iconsax, you'd need to add the iconsax package to pubspec.yaml
// import 'package:iconsax/iconsax.dart';

class TherapistDashboardView extends GetView<TherapistDashboardController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            'Therapist Dashboard',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color(0xFF0D9488), // Modern teal
          centerTitle: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
            unselectedLabelStyle: GoogleFonts.inter(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: Colors.white),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Schedule'),
              Tab(text: 'AI Persona'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildScheduleTab(),
            _buildAIPersonaTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _buildWelcomeHeader(),
          SizedBox(height: 24),

          // Stats Cards
          _buildStatsCards(),
          SizedBox(height: 24),

          // Progress Report Section
          _buildProgressReport(),
          SizedBox(height: 24),

          // Associated Children
          _buildAssociatedChildren(),
          SizedBox(height: 24),

          // My Tasks
          _buildMyTasks(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0D9488).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Dr. Therapist',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Premium',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.9,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          title: 'My Rating',
          value: '${controller.currentRating.value}',
          subtitle: '/5.0',
          icon: Icons.star_rounded,
          color: Color(0xFFFFD700),
          iconColor: Color(0xFFFFC107),
        ),
        _buildStatCard(
          title: 'Children',
          value: '${controller.totalChildren.value}',
          subtitle: 'Associated',
          icon: Icons.group_rounded,
          color: Color(0xFF3B82F6),
          iconColor: Color(0xFF60A5FA),
        ),
        _buildStatCard(
          title: 'Pending Tasks',
          value: '${controller.pendingTasks.value}',
          subtitle: 'To complete',
          icon: Icons.task_alt_rounded,
          color: Color(0xFF8B5CF6),
          iconColor: Color(0xFFA78BFA),
        ),
        _buildStatCard(
          title: 'Sessions',
          value: '${controller.completedSessions.value}',
          subtitle: 'Completed',
          icon: Icons.check_circle_rounded,
          color: Color(0xFF10B981),
          iconColor: Color(0xFF34D399),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressReport() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Report',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Weekly progress overview',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF0D9488).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: GoogleFonts.inter(fontSize: 12),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: GoogleFonts.inter(fontSize: 12),
              ),
              palette: [Color(0xFF0D9488), Color(0xFF14B8A6)],
              plotAreaBorderColor: Colors.transparent,
              series: <LineSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: controller.progressData,
                  xValueMapper: (ChartData data, _) => data.week,
                  yValueMapper: (ChartData data, _) => data.progress,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: GoogleFonts.inter(fontSize: 10),
                  ),
                  animationDuration: 1500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssociatedChildren() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Associated Children',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${controller.childrenList.length} active patients',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.child_care_rounded,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: controller.childrenList.map((child) => _buildChildItem(child)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildItem(ChildData child) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: child.color,
            radius: 24,
            child: Text(
              child.name[0],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  child.condition,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: child.progress / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(child.color),
                  strokeWidth: 6,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${child.progress}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: child.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyTasks() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Tasks',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${controller.tasksList.where((t) => !t.isCompleted).length} pending tasks',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: controller.tasksList.map((task) => _buildTaskItem(task)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskData task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? Color(0xFF10B981).withOpacity(0.1)
                        : Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    task.isCompleted ? Icons.check_rounded : Icons.schedule_rounded,
                    color: task.isCompleted ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.inter(
                          color: task.isCompleted ? Colors.grey[500] : Color(0xFF1E293B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Weekly session chart
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Sessions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: GoogleFonts.inter(fontSize: 12),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: GoogleFonts.inter(fontSize: 12),
                      ),
                      palette: [Color(0xFF0D9488)],
                      series: <ColumnSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                          dataSource: controller.sessionData,
                          xValueMapper: (ChartData data, _) => data.week,
                          yValueMapper: (ChartData data, _) => data.progress,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: GoogleFonts.inter(fontSize: 10),
                          ),
                          animationDuration: 1500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Calendar
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SfCalendar(
                  view: CalendarView.week,
                  dataSource: _getCalendarDataSource(),
                  monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  ),
                  todayHighlightColor: Color(0xFF0D9488),
                  selectionDecoration: BoxDecoration(
                    color: Color(0xFF0D9488).withOpacity(0.1),
                    border: Border.all(color: Color(0xFF0D9488)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  cellBorderColor: Colors.grey[200],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    return _DataSource(controller.appointments);
  }

  Widget _buildAIPersonaTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.inter(),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF0D9488),
              ),
              tabs: [
                Tab(
                  icon: Icon(Icons.model_training_rounded, size: 20),
                  text: 'Train AI',
                ),
                Tab(
                  icon: Icon(Icons.play_circle_fill_rounded, size: 20),
                  text: 'Test AI',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTrainAI(),
                _buildTestAI(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainAI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAICard(
            icon: Icons.cloud_upload_rounded,
            title: 'Training Data Upload',
            description: 'Upload session recordings and notes for AI training',
            buttonText: 'Upload Files',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildAICard(
            icon: Icons.tune_rounded,
            title: 'Model Parameters',
            description: 'Adjust AI response style and personality traits',
            buttonText: 'Configure',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
            ),
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildAICard(
            icon: Icons.analytics_rounded,
            title: 'Training Progress',
            description: 'Monitor AI learning progress and accuracy',
            buttonText: 'View Analytics',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTestAI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAICard(
            icon: Icons.chat_bubble_rounded,
            title: 'Interactive Chat',
            description: 'Test AI responses in simulated conversations',
            buttonText: 'Start Chat',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF43CBFF), Color(0xFF9708CC)],
            ),
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildAICard(
            icon: Icons.play_circle_fill_rounded,
            title: 'Scenario Testing',
            description: 'Test AI with predefined therapy scenarios',
            buttonText: 'Run Tests',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFCCF31), Color(0xFFF55555)],
            ),
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildAICard(
            icon: Icons.assessment_rounded,
            title: 'Performance Metrics',
            description: 'View AI performance scores and feedback',
            buttonText: 'View Report',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF17EAD9), Color(0xFF6078EA)],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAICard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: gradient.colors.first,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}