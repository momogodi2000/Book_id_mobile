import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cni/Services/auth_services.dart';
import '../../../../models/admin_models/statistic.dart';
import '../../../header/admin_header.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Future<List<Statistic>> statistics;

  @override
  void initState() {
    super.initState();
    statistics = Authservices().fetchStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminHeaderPage(), // Updated appBar
      drawer: AdminDashboardDrawer(), // Added drawer
      body: FutureBuilder<List<Statistic>>(
        future: statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Available'));
          }

          final data = snapshot.data!;
          final screenWidth = MediaQuery.of(context).size.width;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  padding: EdgeInsets.all(16.0),
                  child: AspectRatio(
                    aspectRatio: screenWidth > 600 ? 1.5 : 1.0,
                    child: PieChart(
                      PieChartData(
                        sections: data
                            .map((stat) => PieChartSectionData(
                          value: stat.count.toDouble(),
                          title: '${stat.category} (${stat.count})',
                          color: Colors.primaries[data.indexOf(stat) % Colors.primaries.length],
                          radius: screenWidth > 600 ? 70 : 50,
                          titleStyle: TextStyle(
                            fontSize: screenWidth > 600 ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ))
                            .toList(),
                        borderData: FlBorderData(show: false),
                        centerSpaceRadius: screenWidth > 600 ? 50 : 40,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space between chart and table
                // Table
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth > 600 ? 600 : screenWidth,
                    ),
                    child: DataTable(
                      columnSpacing: 16,
                      columns: [
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Count')),
                      ],
                      rows: data
                          .map((stat) => DataRow(cells: [
                        DataCell(Text(stat.category)),
                        DataCell(Text(stat.count.toString())),
                      ]))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
