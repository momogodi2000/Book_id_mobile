import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../../header/clients_header.dart';
// Assuming this is your custom drawer file

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String message = _messageController.text;

      try {
        await Provider.of<Authservices>(context, listen: false)
            .contactUs(name, email, message); // Include name in the API call if needed
        _showSnackbar('Message sent successfully!');
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } catch (error) {
        _showSnackbar('Failed to send message: $error');
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(), // Replacing the default AppBar with ClientHeaderPage
      drawer: const ClientDashboardDrawer(), // Adding the ClientDashboardDrawer
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.05,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildAnimatedContactImage(screenWidth)),
                SizedBox(height: screenHeight * 0.03),
                const Center(
                  child: Text(
                    'We would love to hear from you!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Center(
                  child: Text(
                    'If you have any questions or need clarification, just leave a message and we will reply promptly.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Enter your name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  hintText: 'Enter your message',
                  icon: Icons.message,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildAnimatedContactImage(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Image.asset(
              'assets/icons/logo1.ico', // Add your image asset here
              width: screenWidth * 0.5,
            ),
          ),
        );
      },
    );
  }
}
