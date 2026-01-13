import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class BehaviorDetailsScreen extends StatelessWidget {
  final String childId;
  final String behaviorId;

  BehaviorDetailsScreen({required this.childId, required this.behaviorId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Behavior Details'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.auto_mode),
            onPressed: () => themeProvider.setSystemTheme(),
            tooltip: 'Set System Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBehaviorInfoCard(context),
            SizedBox(height: 24),
            _buildBehaviorChart(context),
            SizedBox(height: 24),
            _buildAddInstanceButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('children')
              .doc(childId)
              .collection('behaviors')
              .doc(behaviorId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final behavior = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(behavior['name'], style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Text(behavior['description'], style: Theme.of(context).textTheme.bodyMedium),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBehaviorChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Behavior Frequency', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('children')
                    .doc(childId)
                    .collection('behaviors')
                    .doc(behaviorId)
                    .collection('instances')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final instances = snapshot.data!.docs;
                  final data = instances.map((doc) {
                    final timestamp = (doc['timestamp'] as Timestamp).toDate();
                    return FlSpot(timestamp.millisecondsSinceEpoch.toDouble(), 1);
                  }).toList();

                  return LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                          isCurved: true,
                          barWidth: 3,
                          color: Theme.of(context).colorScheme.primary,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                              return Text('${date.month}/${date.day}');
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
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

  Widget _buildAddInstanceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _firestore
            .collection('children')
            .doc(childId)
            .collection('behaviors')
            .doc(behaviorId)
            .collection('instances')
            .add({
          'timestamp': Timestamp.now(),
        });
      },
      child: Text('Add Instance'),
    );
  }
}
