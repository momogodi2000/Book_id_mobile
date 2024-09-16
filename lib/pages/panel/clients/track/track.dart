import 'package:flutter/material.dart';
import '../../../header/clients_header.dart';
// Adjust the import path as necessary

class TrackPage extends StatelessWidget {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(),
      drawer: const ClientDashboardDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedHeader(screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildTrackForm(screenWidth, screenHeight, context),
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
          child: Text(
            'Check Your ID Card Status',
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

  Widget _buildTrackForm(double screenWidth, double screenHeight, BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String identificationNumber = '';
    String name = '';
    DateTime selectedDate = DateTime.now();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Identification Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Identification Number';
              }
              return null;
            },
            onSaved: (value) {
              identificationNumber = value!;
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Full Name';
              }
              return null;
            },
            onSaved: (value) {
              name = value!;
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  _checkStatus(context, identificationNumber, name, selectedDate);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Track Status',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkStatus(BuildContext context, String idNumber, String name, DateTime date) {
    // Simulate a database call to check the ID card status
    bool isAvailable = _mockDatabaseCheck(idNumber, name, date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isAvailable ? 'ID Card Available' : 'ID Card Not Available'),
          content: Text(isAvailable
              ? 'Your National ID Card is ready for pickup.'
              : 'Your National ID Card is not yet ready. Please check back later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _mockDatabaseCheck(String idNumber, String name, DateTime date) {
    // This is a mock function to simulate checking the database
    // Replace this with actual database interaction
    return idNumber == '123456' && name == 'John Doe' && date.year == 1990;
  }
}