import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Services/auth_services.dart';

class AddCommunicationPage extends StatefulWidget {
  const AddCommunicationPage({super.key});

  @override
  _AddCommunicationPageState createState() => _AddCommunicationPageState();
}

class _AddCommunicationPageState extends State<AddCommunicationPage> {
  final TextEditingController titleController = TextEditingController();
  String? selectedFile;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> addCommunication() async {
    final authServices = Provider.of<Authservices>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    try {
      await authServices.addCommunication(
        titleController.text,
        selectedFile!,
      );
      Navigator.of(context).pop(); // Go back to the communication list after adding
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> selectFile() async {
    final action = await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              child: const Text('Camera'),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        );
      },
    );

    if (action != null) {
      final pickedFile = await _picker.pickImage(
        source: action,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          selectedFile = pickedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Communication'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedText('Title', screenWidth),
              SizedBox(height: screenHeight * 0.01),
              _buildTextField(),
              SizedBox(height: screenHeight * 0.02),
              _buildAnimatedText('File', screenWidth),
              SizedBox(height: screenHeight * 0.01),
              _buildFileSelectionButton(),
              if (selectedFile != null) ...[
                SizedBox(height: screenHeight * 0.02),
                _buildImagePreview(screenHeight, screenWidth),
              ],
              SizedBox(height: screenHeight * 0.04),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text, double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        hintText: 'Enter title here...',
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildFileSelectionButton() {
    return ElevatedButton.icon(
      onPressed: selectFile,
      icon: const Icon(Icons.file_upload),
      label: Text(selectedFile != null ? 'Change File' : 'Select File'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildImagePreview(double screenHeight, double screenWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        File(selectedFile!),
        height: screenHeight * 0.3,
        width: screenWidth,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: addCommunication,
      icon: const Icon(Icons.add),
      label: const Text('Add Communication'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}