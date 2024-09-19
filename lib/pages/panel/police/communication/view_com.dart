import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../../header/police_header.dart';
import 'Addcommunication.dart';


class CommunicationPage extends StatefulWidget {
  const CommunicationPage({super.key});

  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  List<dynamic> communications = [];
  bool isLoading = true;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    fetchCommunications();
  }

  Future<void> fetchCommunications() async {
    final authServices = Provider.of<Authservices>(context, listen: false);
    try {
      final data = await authServices.fetchCommunications();
      setState(() {
        communications = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> deleteCommunication(int id) async {
    final authServices = Provider.of<Authservices>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    try {
      await authServices.deleteCommunication(id);
      fetchCommunications();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void editCommunication(Map<String, dynamic> communication) {
    final titleController = TextEditingController(text: communication['title']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Communication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                _selectedImagePath != null
                    ? Image.file(File(_selectedImagePath!), height: 100)
                    : const SizedBox.shrink(),
                TextButton(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImagePath = pickedFile.path;
                      });
                    }
                  },
                  child: const Text('Upload Image from Gallery'),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImagePath = pickedFile.path;
                      });
                    }
                  },
                  child: const Text('Upload Image from Camera'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text;

                if (title.isNotEmpty) {
                  final authServices = Provider.of<Authservices>(context, listen: false);
                  try {
                    await authServices.editCommunication(
                      communication['id'],
                      title,
                      _selectedImagePath!,
                    );
                    fetchCommunications();
                    Navigator.of(context).pop();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAddCommunicationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
            padding: const EdgeInsets.all(16),
            child: const AddCommunicationPage(),
          ),
        );
      },
    ).then((_) => fetchCommunications());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PoliceHeaderPage(), // Using the imported PoliceHeaderPage
      drawer: const PoliceDashboardDrawer(), // Using the imported PoliceDashboardDrawer
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedHeader(screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildCommunicationList(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCommunicationDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Buttons moved down
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blueAccent),
              onPressed: () {
                // Navigate to home or any other action
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.blueAccent),
              onPressed: () {
                // Notifications action
              },
            ),
          ],
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
            'Recent Communications',
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

  Widget _buildCommunicationList(double screenWidth, double screenHeight) {
    return Column(
      children: communications.map((communication) {
        return _buildCommunicationCard(communication, screenWidth, screenHeight);
      }).toList(),
    );
  }

  Widget _buildCommunicationCard(Map<String, dynamic> communication, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "http://192.168.100.5:8000/" + communication['location'],
                      width: screenWidth,
                      height: screenHeight * 0.25,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Title: ${communication['title']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => editCommunication(communication),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => deleteCommunication(communication['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
