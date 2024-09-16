import 'package:flutter/material.dart';

import '../../../header/clients_header.dart';

class PoliceOfficerGradesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(), // Custom app bar widget
      drawer: const ClientDashboardDrawer(), // Custom drawer widget
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Cameroon Police Officer Grades',
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildPoliceCorpsGrid(context, screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliceCorpsGrid(BuildContext context, double screenWidth) {
    final List<Map<String, String>> policeCorps = [
      {
        'title': 'National Police',
        'image': 'assets/images/national_police.jpeg',
        'description': 'Responsible for maintaining public order and safety in urban areas.',
      },
      {
        'title': 'Judicial Police',
        'image': 'assets/images/judicial_police.jpeg',
        'description': 'Handles criminal investigations and supports the judicial system.',
      },
      {
        'title': 'National Gendarmerie',
        'image': 'assets/images/gendarmerie.jpeg',
        'description': 'A paramilitary force with both military and police duties.',
      },
      {
        'title': 'Assistant Police',
        'image': 'assets/images/assistant.jpeg',
        'description': 'Supervises a team of Police Officers.',
      },
      {
        'title': 'Sergeant',
        'image': 'assets/images/sergeant.jpeg',
        'description': 'Leads a larger team and provides tactical leadership.',
      },
      {
        'title': 'Inspector',
        'image': 'assets/images/ip.jpeg',
        'description': 'Investigates crimes and supervises lower ranks.',
      },
      {
        'title': 'Senior Inspector',
        'image': 'assets/images/so.jpeg',
        'description': 'Leads investigations and manages units.',
      },
      {
        'title': 'Police Officer',
        'image': 'assets/images/police2.jpeg',
        'description': 'Holds a leadership position such as company commander.',
      },
      {
        'title': 'Commissioner',
        'image': 'assets/images/tenue.jpeg',
        'description': 'Oversees larger units such as districts or departments.',
      },
      {
        'title': 'General Inspector',
        'image': 'assets/images/cyber.jpeg',
        'description': 'Highest rank in the National Police.',
      },
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth < 600 ? 2 : 3,
        childAspectRatio: screenWidth < 600 ? 0.8 : 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: policeCorps.length,
      itemBuilder: (context, index) {
        final corps = policeCorps[index];
        return Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.asset(
                    corps['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      corps['title']!,
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      corps['description']!,
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
