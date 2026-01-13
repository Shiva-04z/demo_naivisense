import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/models/behavior_instance_model.dart';

class GenerateReportScreen extends StatefulWidget {
  final String childId;
  final String behaviorId;

  GenerateReportScreen({required this.childId, required this.behaviorId});

  @override
  _GenerateReportScreenState createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  DateTimeRange? _selectedDateRange;

  void _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange ?? initialDateRange,
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: _selectedDateRange == null
          ? Center(
              child: Text('Please select a date range.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('children')
                  .doc(widget.childId)
                  .collection('behaviors')
                  .doc(widget.behaviorId)
                  .collection('behavior_instances')
                  .where('timestamp', isGreaterThanOrEqualTo: _selectedDateRange!.start)
                  .where('timestamp', isLessThanOrEqualTo: _selectedDateRange!.end)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final instances = snapshot.data!.docs
                    .map((doc) => BehaviorInstance(
                          id: doc.id,
                          timestamp: (doc['timestamp'] as Timestamp).toDate(),
                          comment: doc['comment'],
                        ))
                    .toList();

                final spots = _createChartData(instances);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<FlSpot> _createChartData(List<BehaviorInstance> instances) {
    final Map<DateTime, int> counts = {};
    for (final instance in instances) {
      final date = DateTime(instance.timestamp.year, instance.timestamp.month, instance.timestamp.day);
      counts[date] = (counts[date] ?? 0) + 1;
    }

    return counts.entries
        .map((entry) => FlSpot(entry.key.millisecondsSinceEpoch.toDouble(), entry.value.toDouble()))
        .toList();
  }
}
