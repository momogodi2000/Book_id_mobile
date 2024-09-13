import 'package:flutter/material.dart';

class PoliceOfficerGradesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cameroon Police Officer Grades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cameroon Police Officer Grades',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildPoliceCorpsGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliceCorpsGrid(BuildContext context) {
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
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: policeCorps.length,
      itemBuilder: (context, index) {
        final corps = policeCorps[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, corps['route']!);
          },
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        corps['description']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}