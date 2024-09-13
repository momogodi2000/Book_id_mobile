import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../header/police_header.dart'; // Assuming these imports are correct

class PolicePanelPage extends StatelessWidget {
  const PolicePanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PoliceHeaderPage(), // Using the imported PoliceHeaderPage
      drawer: const PoliceDashboardDrawer(), // Using the imported PoliceDashboardDrawer
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cards section
              _buildCardRow([
                _buildCard('User', Icons.person, Colors.blue),
                _buildCard('Statistics', Icons.bar_chart, Colors.green),
                _buildCard('Analyse', Icons.analytics, Colors.orange),
              ]),
              SizedBox(height: 16),
              _buildCardRow([
                _buildCard('Payments', Icons.payment, Colors.purple),
                _buildCard('Missing ID Card', Icons.credit_card, Colors.red),
                _buildCard('Appointment', Icons.calendar_today, Colors.teal),
              ]),
              SizedBox(height: 24),
              // Static graph table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Graph Table',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: 100,
      height: 100,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle card tap
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardRow(List<Widget> cards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cards,
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Count')),
          DataColumn(label: Text('Status')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('User Registrations')),
            DataCell(Text('150')),
            DataCell(Text('Active')),
          ]),
          DataRow(cells: [
            DataCell(Text('Payments')),
            DataCell(Text('75')),
            DataCell(Text('Pending')),
          ]),
          DataRow(cells: [
            DataCell(Text('Missing ID Cards')),
            DataCell(Text('30')),
            DataCell(Text('Resolved')),
          ]),
          DataRow(cells: [
            DataCell(Text('Appointments')),
            DataCell(Text('120')),
            DataCell(Text('Scheduled')),
          ]),
        ],
      ),
    );
  }
}
