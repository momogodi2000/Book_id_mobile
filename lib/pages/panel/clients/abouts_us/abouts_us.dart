import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _buildAnimatedLogo(screenWidth),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Simplifying the National ID Process',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                'We understand the frustrations and challenges faced by Cameroonians in obtaining their national ID cards. Long queues, bureaucratic delays, and corruption have become synonymous with this essential process.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                "That's why we created [App Name]. Our mission is to revolutionize the way Cameroonians interact with government services by providing a convenient, efficient, and transparent platform to book appointments for national ID card processing.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                'Our Solution:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildBulletPoint(
                'Online Appointment Booking:',
                'Say goodbye to long queues and wasted time. Schedule your appointment at your convenience.',
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildBulletPoint(
                'Real-Time Status Updates:',
                'Track your application progress and receive notifications about appointment changes.',
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildBulletPoint(
                'Transparent Process:',
                'We are committed to transparency. Our platform provides clear information about the ID card process and requirements.',
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildBulletPoint(
                'Reducing Bureaucratic Bottlenecks:',
                'By optimizing appointment scheduling, we help reduce wait times and improve overall efficiency.',
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildBulletPoint(
                'Fighting Corruption:',
                'Our system promotes fairness and equity by eliminating opportunities for bribery and favoritism.',
              ),
              SizedBox(height: screenHeight * 0.04),
              const Text(
                'We believe that every Cameroonian deserves a hassle-free experience when obtaining their national ID card. Join us in building a more efficient and transparent Cameroon.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: Column(
                  children: [
                    _buildAnimatedLogo(screenWidth),
                    SizedBox(height: screenHeight * 0.03),
                    const Text(
                      '[Number: 695 92 20 65]',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      '[yvangodimomo@gmail.com]',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      '[Cameroon]',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Image.asset(
            'assets/icons/logo.jpeg', // Replace with your company logo
            width: screenWidth * 0.4,
          ),
        );
      },
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$title ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: content,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
