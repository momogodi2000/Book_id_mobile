import 'package:flutter/material.dart';

class CombinedContactPage extends StatelessWidget {
  const CombinedContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedHeader(screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildAssistanceSection(screenHeight),
              SizedBox(height: screenHeight * 0.05),
              _buildContactMethods(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              _buildSocialMediaLinks(screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildRegionContacts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Image.asset(
            'assets/icons/logo1.ico', // Replace with a relevant image
            width: screenWidth * 0.7,
          ),
        );
      },
    );
  }

  Widget _buildAssistanceSection(double screenHeight) {
    return Column(
      children: [
        const Text(
          'Need Assistance?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        const Text(
          'Our call center is here to help you with any questions or issues regarding the national ID card process. Our dedicated team is available to assist you.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildContactMethods(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactMethod(
          Icons.phone,
          'Call Us:',
          '+237 695 92 20 65',
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildContactMethod(
          Icons.email,
          'Email Us:',
          'yvangodimomo@gmail.com',
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildContactMethod(
          Icons.message,
          'SMS Support:',
          '+237 695 92 20 65',
        ),
      ],
    );
  }

  Widget _buildContactMethod(IconData icon, String title, String detail) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              detail,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialMediaLinks(double screenWidth) {
    return Column(
      children: [
        const Text(
          'Follow Us on Social Media',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: screenWidth * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialMediaIcon('assets/images/fb.jpeg'), // Replace with actual icons
            SizedBox(width: screenWidth * 0.05),
            _buildSocialMediaIcon('assets/images/x.png'), // Replace with actual icons
            SizedBox(width: screenWidth * 0.05),
            _buildSocialMediaIcon('assets/images/in.jpeg'), // Replace with actual icons
          ],
        ),
      ],
    );
  }

  Widget _buildSocialMediaIcon(String iconPath) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Image.asset(
            iconPath,
            width: 40,
            height: 40,
          ),
        );
      },
    );
  }

  Widget _buildRegionContacts() {
    final List<Map<String, dynamic>> regions = [
      {
        'title': 'Useful Addresses',
        'items': [
          'Judicial Police Directorate (DPJ): 222 23 24 11',
          'Special Operations Group (GSO): 222 30 65 15',
          'Public Utility Number of DGSN: 1 500',
          'Special Rapid Intervention Teams (ESIR): 117 or 17',
          'Diplomats\' Security Company (CSD): 120',
        ],
      },
      {
        'title': 'CENTRE Region',
        'items': [
          'Regional Delegation of National Security: 222 23 26 53',
          'Regional Division of Judicial Police: 222 23 04 22',
        ],
      },
      {
        'title': 'LITTORAL Region',
        'items': [
          'Regional Delegation of National Security: 233 42 78 14',
          'Regional Division of Judicial Police: 233 42 01 36',
        ],
      },
      {
        'title': 'NORTHWEST Region',
        'items': [
          'Regional Delegation of National Security: 233 36 12 54',
          'Regional Division of Judicial Police: 233 36 16 71',
        ],
      },
      {
        'title': 'SOUTHWEST Region',
        'items': [
          'Regional Delegation of National Security: 233 33 23 59',
          'Regional Division of Judicial Police: 233 33 21 09',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: regions.map((region) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                region['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...region['items'].map((item) => ListTile(
                title: Text(item),
                contentPadding: EdgeInsets.zero,
              )),
              Divider(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
