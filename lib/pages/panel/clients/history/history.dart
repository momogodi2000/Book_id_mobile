import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History of National ID Card'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'History of the National ID Card in Cameroon',
                    screenWidth,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionContent(
                    'The National ID card in Cameroon has a rich history dating back to the post-independence era. Initially introduced as a means to establish the identity of citizens, it has evolved over the decades to become a crucial document for various administrative processes. The current biometric ID card, introduced in the 2000s, is a reflection of the government’s efforts to modernize and secure identification processes.',
                    screenWidth,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    'Importance of Having a National ID Card',
                    screenWidth,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionContent(
                    'The National ID card serves as a primary identification document for Cameroonian citizens. It is essential for:\n\n1. Voting in elections and exercising civic duties.\n2. Accessing government services and benefits.\n3. Applying for jobs and enrolling in educational institutions.\n4. Opening bank accounts and carrying out financial transactions.\n5. Traveling within and outside the country with ease.',
                    screenWidth,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    'Services Provided by the National ID Card',
                    screenWidth,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionContent(
                    'The National ID card is not just an identification document; it provides access to various services such as:\n\n1. Authentication and verification of identity for legal processes.\n2. Enrollment in national programs like social security and healthcare.\n3. Facilitation of digital services and e-governance initiatives.\n4. Access to credit and financial services, including loans and insurance.\n5. Securing civil rights and legal recognition for individuals.',
                    screenWidth,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth < 600 ? 12 : 16,
                          horizontal: screenWidth < 600 ? 24 : 32,
                        ),
                        backgroundColor: Colors.blueAccent,
                        textStyle: TextStyle(
                          fontSize: screenWidth < 600 ? 16 : 18,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth < 600 ? 20 : 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildSectionContent(String content, double screenWidth) {
    return Text(
      content,
      style: TextStyle(
        fontSize: screenWidth < 600 ? 16 : 18,
        height: 1.5,
      ),
    );
  }
}