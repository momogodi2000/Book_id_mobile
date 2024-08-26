import 'package:flutter/material.dart';

class FindIDPage extends StatelessWidget {
  const FindIDPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Found National ID Cards'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildDescription(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildIDCardList(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Missing National IDs Found',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription(double screenWidth) {
    return Text(
      'Below is a list of national ID cards that have been found. '
          'If your ID is listed, please contact the finder.',
      style: TextStyle(
        fontSize: screenWidth * 0.045,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildIDCardList(double screenHeight, double screenWidth) {
    // Example data (replace with your actual data)
    final List<Map<String, String>> foundIDs = [
      {
        'username': 'John Doe',
        'dateFound': '2024-08-15',
        'phoneNumber': '123-456-7890',
        'email': 'john.doe@example.com',
        'imagePath': 'assets/images/momo.jpg', // Replace with actual image paths
      },
      {
        'username': 'Jane Smith',
        'dateFound': '2024-08-10',
        'phoneNumber': '987-654-3210',
        'email': 'jane.smith@example.com',
        'imagePath': 'assets/images/auth.jpeg', // Replace with actual image paths
      },
      // Add more entries as needed
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foundIDs.length,
      itemBuilder: (context, index) {
        final idCard = foundIDs[index];
        return Card(
          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Found by: ${idCard['username']}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Date Found: ${idCard['dateFound']}',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Contact: ${idCard['phoneNumber']}',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                Text(
                  'Email: ${idCard['email']}',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.02),
                Image.asset(
                  idCard['imagePath']!,
                  height: screenHeight * 0.25,
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
