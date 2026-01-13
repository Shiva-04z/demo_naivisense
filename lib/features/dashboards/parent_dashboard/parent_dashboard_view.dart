import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/dashboards/parent_dashboard/parent_dashboard_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'parent_dashboard_controller.dart';

import 'dart:ui' as ui;

class ParentDashboardView extends GetView<ParentDashboardController> {
  // Color palette
  static const Color primaryTeal = Color(0xFF008080);
  static const Color darkTeal = Color(0xFF006666);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF008080), Color(0xFF4DB6AC)],
  );
  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF80CBC4), Color(0xFFE0F2F1)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTeal,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Child Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: primaryTeal,
            elevation: 0,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: accentGradient,
                ),
                child: IconButton(
                  icon: Icon(Icons.download, color: darkTeal),
                  onPressed: _downloadTimeline,
                  tooltip: 'Download Timeline',
                ),
              ),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeaderSection(),
                _buildTabBar(),
                Obx(() {
                  if (controller.currentPageIndex.value == 0) {
                    return _buildDashboardTab();
                  } else {
                    return _buildBeautifulTimelineTab();
                  }
                }),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeautifulTimelineTab() {
    final sortedEvents = controller.getSortedTimelineEvents();
    final allEvents = controller.getCombinedTimelineData();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Elegant Header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  darkTeal,
                  primaryTeal,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: darkTeal.withOpacity(0.3),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Therapy Journey',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Complete history with milestones',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.white, size: 22),
                    onPressed: _downloadTimeline,
                    tooltip: 'Download Timeline',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Modern Timeline Container
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.08),
                  blurRadius: 40,
                  offset: Offset(0, 15),
                  spreadRadius: -10,
                ),
                BoxShadow(
                  color: Colors.teal.withOpacity(0.03),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.teal.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Interactive Chart
                Container(
                  height: 200,
                  child: SfCartesianChart(
                    margin: EdgeInsets.all(0),
                    plotAreaBorderWidth: 0,
                    primaryXAxis: DateTimeAxis(
                      intervalType: DateTimeIntervalType.days,
                      interval: 7,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      majorGridLines: MajorGridLines(
                        width: 1,
                        color: Colors.grey[100],
                      ),
                      axisLine: AxisLine(
                        width: 1,
                        color: Colors.teal.withOpacity(0.3),
                      ),
                      dateFormat: null,
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                      maximum: 5,
                      minimum: 0,
                    ),
                    series: <CartesianSeries>[
                      LineSeries<TimelineEvent, DateTime>(
                        dataSource: sortedEvents,
                        xValueMapper: (TimelineEvent event, _) => event.date,
                        yValueMapper: (TimelineEvent event, _) => 2.5,
                        name: 'Timeline',
                        color: primaryTeal.withOpacity(0.2),
                        width: 2,
                        dashArray: [5, 5],
                      ),
                      ScatterSeries<TimelineEvent, DateTime>(
                        dataSource: sortedEvents,
                        xValueMapper: (TimelineEvent event, _) => event.date,
                        yValueMapper: (TimelineEvent event, _) =>
                            _getEventYPosition(event.type),
                        name: 'Events',
                        color: primaryTeal,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          borderWidth: 3,
                          borderColor: accentTeal,
                          width: 14,
                          height: 14,
                        ),
                      ),
                      ScatterSeries<Milestone, DateTime>(
                        dataSource: controller.milestones,
                        xValueMapper: (Milestone milestone, _) => milestone.date,
                        yValueMapper: (Milestone milestone, _) => milestone.value,
                        name: 'Milestones',
                        color: Color(0xFFFFB74D),
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.diamond,
                          borderWidth: 3,
                          borderColor: Color(0xFFFF9800),
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      builder: (dynamic data, dynamic point, dynamic series,
                          int pointIndex, int seriesIndex) {
                        if (data is TimelineEvent) {
                          return _buildEventTooltip(data);
                        } else if (data is Milestone) {
                          return _buildMilestoneTooltip(data);
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 150),

                // Elegant Vertical Timeline
                _buildVerticalTimeline(allEvents),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTimeline(List<dynamic> events) {
    return Container(
      child: Stack(
        children: [
          // Vertical Line with Gradient
          Positioned(
            left: 30,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryTeal.withOpacity(0.8),
                    accentTeal.withOpacity(0.8),
                    Colors.teal.shade200.withOpacity(0.8),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),

          // Timeline Items
          Column(
            children: events.reversed.toList()
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final event = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Indicator
                    Container(
                      width: 60,
                      child: Column(
                        children: [
                          // Indicator Dot
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: _getEventGradient(event),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getEventColor(event).withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getEventIcon(event),
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Connector Line
                          if (index < events.length - 1)
                            Container(
                              width: 2,
                              height: 70,
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _getEventColor(event).withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),

                    // Event Card
                    Expanded(
                      child: _buildTimelineEventCard(event),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEventCard(dynamic event) {
    final bool isMilestone = event is Milestone;

    return Transform.translate(
      offset: Offset(0, -8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.05),
              blurRadius: 30,
              offset: Offset(0, 15),
              spreadRadius: -5,
            ),
          ],
          border: Border.all(
            color: _getEventColor(event).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Header with Icon
                Row(
                children: [
                Container(
                width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _getEventGradient(event),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _getEventColor(event).withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getEventIcon(event),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getEventTitle(event),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkTeal,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
                ],
              ),
                    SizedBox(height: 4),
                    if (isMilestone)
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFB74D),
                                  Color(0xFFFF9800),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star,
                                    size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'MILESTONE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(_getEventDate(event)),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              SizedBox(height: 20),

              // Description
              Text(
                _getEventDescription(event),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16),

              // Footer
              Container(
                padding: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(
                color: Colors.teal.withOpacity(0.1),
                width: 1,
              ),)
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getEventColor(event).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getEventColor(event).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getEventType(event).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getEventColor(event),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 6),
                Text(
                  '${_getEventDate(event).hour}:${_getEventDate(event).minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
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
    ),
    ),
    );
  }

  Widget _buildEventTooltip(TimelineEvent event) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            lightTeal,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.teal.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: _getEventGradient(event),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(event.icon, size: 18, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkTeal,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            event.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: accentTeal),
              SizedBox(width: 6),
              Text(
                _formatDate(event.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneTooltip(Milestone milestone) {
    return Container(
      width: 300,
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8E1),
            Colors.white,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFB74D),
                      Color(0xFFFF9800),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.star, size: 18, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                'Milestone Achieved!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            milestone.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            milestone.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.celebration, size: 14, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  _formatDate(milestone.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  double _getEventYPosition(String type) {
    switch (type) {
      case 'task':
        return 1.5;
      case 'diet':
        return 2.0;
      case 'therapy':
        return 2.5;
      case 'test':
        return 3.0;
      case 'milestone':
        return 3.5;
      default:
        return 2.0;
    }
  }

  Color _getEventColor(dynamic event) {
    if (event is TimelineEvent) return event.color;
    if (event is Milestone) return event.color;
    return primaryTeal;
  }

  Gradient _getEventGradient(dynamic event) {
    final Color baseColor = _getEventColor(event);
    return LinearGradient(
      colors: [
        baseColor,
        Color.lerp(baseColor, Colors.white, 0.2)!,
      ],
    );
  }

  IconData _getEventIcon(dynamic event) {
    if (event is TimelineEvent) return event.icon;
    if (event is Milestone) return event.icon;
    return Icons.event;
  }

  String _getEventTitle(dynamic event) {
    if (event is TimelineEvent) return event.title;
    if (event is Milestone) return event.title;
    return '';
  }

  String _getEventDescription(dynamic event) {
    if (event is TimelineEvent) return event.description;
    if (event is Milestone) return event.description;
    return '';
  }

  DateTime _getEventDate(dynamic event) {
    if (event is TimelineEvent) return event.date;
    if (event is Milestone) return event.date;
    return DateTime.now();
  }

  String _getEventType(dynamic event) {
    if (event is TimelineEvent) return event.type;
    if (event is Milestone) return 'milestone';
    return 'event';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _downloadTimeline() {
    Get.dialog(
      AlertDialog(
        title: Text('Download Timeline',
            style: TextStyle(color: darkTeal, fontWeight: FontWeight.bold)),
        content: Text('Would you like to download the timeline as PDF or PNG?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey[600])),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Download Started',
                  'Your timeline will be downloaded shortly',
                  backgroundColor: primaryTeal,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Text('Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            lightTeal,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back, Parent!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkTeal,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tracking progress together',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 24),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = controller.getProgressPercentage();
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, accentTeal],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.getCompletedTasks().length} tasks completed',
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
              Text(
                '${controller.getUpcomingTasks().length} remaining',
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: lightTeal,
          width: 1,
        ),
      ),
      child: Obx(() {
        return Row(
          children: [
            _buildTabItem('Dashboard', 0),
            _buildTabItem('Timeline', 1),
          ],
        );
      }),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changePageIndex(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: controller.currentPageIndex.value == index
                ? primaryGradient
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: controller.currentPageIndex.value == index
                    ? Colors.white
                    : Colors.grey[600],
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return Column(
      children: [
        SizedBox(height: 16),
        _buildCurrentPlanSection(),
        SizedBox(height: 20),
        _buildImprovementChartSection(),
        SizedBox(height: 20),
        _buildTasksSection(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCurrentPlanSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Plan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: darkTeal,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildPlanCard(
                'Active Therapy',
                controller.currentPlan['activeTherapy'],
                Icons.medical_services,
                primaryTeal,
              ),
              _buildPlanCard(
                'Diet Plan',
                controller.currentPlan['dietPlan'],
                Icons.restaurant,
                Color(0xFF4CAF50),
              ),
              _buildPlanCard(
                'Exercise Plan',
                controller.currentPlan['exercisePlan'],
                Icons.directions_run,
                Color(0xFFFF9800),
              ),
              _buildPlanCard(
                'Next Session',
                controller.currentPlan['nextSession'],
                Icons.calendar_today,
                Color(0xFF9C27B0),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildTherapistSection(),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String title, String value, IconData icon,
      Color color) {
    return Container(
      width: (Get.width - 56) / 2,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.teal.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkTeal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: lightTeal,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTeal,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.currentPlan['center'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTherapistCard(
                  controller.currentPlan['therapist1'],
                  controller.currentPlan['therapist1Specialty'],
                  'assets/therapist1.png',
                  primaryTeal,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTherapistCard(
                  controller.currentPlan['therapist2'],
                  controller.currentPlan['therapist2Specialty'],
                  'assets/therapist2.png',
                  accentTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistCard(String name, String specialty, String image,
      Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(Icons.person, size: 40, color: color),
            ),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkTeal,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            specialty,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementChartSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: lightTeal,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Improvement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTeal,
                ),
              ),
              Obx(() {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: lightTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedTimeRange.value,
                      items: controller.timeRanges.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: darkTeal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.changeTimeRange(value!);
                      },
                      icon: Icon(Icons.arrow_drop_down, color: darkTeal),
                      dropdownColor: Colors.white,
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: 300,
            child: SfCartesianChart(
              margin: EdgeInsets.all(0),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                axisLine: AxisLine(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(fontSize: 12),
                numberFormat: null,
                axisLine: AxisLine(width: 0),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: controller.getImprovementChartData(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  name: 'Current',
                  color: primaryTeal,
                  width: 0.6,
                  spacing: 0.2,
                ),
                ColumnSeries<ChartData, String>(
                  dataSource: controller.getImprovementChartData(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  name: 'Previous',
                  color: Color(0xFFE0F2F1),
                  width: 0.6,
                  spacing: 0.2,
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                  color: darkTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks Assigned',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTeal,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...controller.getUpcomingTasks().take(3).map((task) {
            return _buildTaskItem(task);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.teal.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getTaskColor(task.priority),
                  _getTaskColor(task.priority).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTaskIcon(task.category),
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: darkTeal,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: accentTeal),
                    SizedBox(width: 6),
                    Text(
                      'Due: ${_formatDate(task.dueDate)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),

           Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? primaryTeal : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {},
                activeColor: primaryTeal,
                checkColor: Colors.white,
                shape: CircleBorder(),
                side: BorderSide.none,
              ),
            ),

        ],
      ),
    );
  }

  // Helper methods
  Color _getTaskColor(String priority) {
    switch (priority) {
      case 'high':
        return Color(0xFFF44336);
      case 'medium':
        return Color(0xFFFF9800);
      case 'low':
        return Color(0xFF4CAF50);
      default:
        return primaryTeal;
    }
  }

  IconData _getTaskIcon(String category) {
    switch (category) {
      case 'exercise':
        return Icons.directions_run;
      case 'diet':
        return Icons.restaurant;
      case 'therapy':
        return Icons.medical_services;
      default:
        return Icons.task_alt;
    }
  }

  double _getEventYValue(String type) {
    switch (type) {
      case 'task':
        return 1;
      case 'diet':
        return 2;
      case 'therapy':
        return 3;
      case 'test':
        return 4;
      case 'milestone':
        return 5;
      default:
        return 1;
    }
  }
}

class _DiamondPatternPainter extends CustomPainter {
  final Color color;

  _DiamondPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double step = 20;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        if ((x ~/ step + y ~/ step) % 2 == 0) {
          path.moveTo(x, y + step / 2);
          path.lineTo(x + step / 2, y);
          path.lineTo(x + step, y + step / 2);
          path.lineTo(x + step / 2, y + step);
          path.close();
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}