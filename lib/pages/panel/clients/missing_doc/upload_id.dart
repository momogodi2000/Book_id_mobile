import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../../../../Services/auth_services.dart';
import '../../../header/clients_header.dart';

class UploadIDPage extends StatefulWidget {
  const UploadIDPage({super.key});

  @override
  _UploadIDPageState createState() => _UploadIDPageState();
}

class _UploadIDPageState extends State<UploadIDPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String username = '';
  String phoneNumber = '';
  String email = '';
  DateTime selectedDate = DateTime.now();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _uploadID() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();

      try {
        await context.read<Authservices>().uploadID(
          username: username,
          phone: phoneNumber,
          email: email,
          dateFound: selectedDate, // Pass the DateTime object
          imagePath: _image!.path,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID uploaded successfully!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(), // Updated with ClientHeaderPage
      drawer: const ClientDashboardDrawer(), // Updated with ClientDashboardDrawer
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedHeader(screenWidth),
                SizedBox(height: screenHeight * 0.05),
                _buildUsernameField(),
                SizedBox(height: screenHeight * 0.03),
                _buildPhoneNumberField(),
                SizedBox(height: screenHeight * 0.03),
                _buildEmailField(),
                SizedBox(height: screenHeight * 0.03),
                _buildDatePicker(context),
                SizedBox(height: screenHeight * 0.03),
                _buildImagePicker(screenHeight),
                SizedBox(height: screenHeight * 0.05),
                _buildUploadButton(screenWidth, screenHeight),
              ],
            ),
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
            'Upload Found National ID',
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

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
      onSaved: (value) {
        username = value!;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
      onSaved: (value) {
        phoneNumber = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date Found',
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
              setState(() {
                selectedDate = picked;
              });
            }
          },
        ),
      ),
      controller: TextEditingController(
        text: "${selectedDate.toLocal()}".split(' ')[0],
      ),
    );
  }

  Widget _buildImagePicker(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Image of ID Card',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        _image == null
            ? const Text('No image selected.')
            : Image.file(
          File(_image!.path),
          height: screenHeight * 0.3,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildUploadButton(double screenWidth, double screenHeight) {
    return Center(
      child: ElevatedButton(
        onPressed: _uploadID,
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
          'Upload ID',
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
      ),
    );
  }
}
