import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../../header/admin_header.dart';
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
    setState(() => isLoading = true);

    try {
      final data = await authServices.fetchCommunications();
      setState(() {
        communications = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() => isLoading = false);
      _showErrorSnackBar(error.toString());
    }
  }

  Future<void> deleteCommunication(int id) async {
    final authServices = Provider.of<Authservices>(context, listen: false);
    setState(() => isLoading = true);

    try {
      await authServices.deleteCommunication(id);
      fetchCommunications();
    } catch (error) {
      setState(() => isLoading = false);
      _showErrorSnackBar(error.toString());
    }
  }

  void editCommunication(Map<String, dynamic> communication) {
    final titleController = TextEditingController(text: communication['title']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Communication'),
          content: _buildEditCommunicationDialogContent(titleController),
          actions: _buildEditCommunicationDialogActions(communication['id'], titleController),
        );
      },
    );
  }

  Widget _buildEditCommunicationDialogContent(TextEditingController titleController) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          if (_selectedImagePath != null) Image.file(File(_selectedImagePath!), height: 100),
          _buildImagePickerButtons(),
        ],
      ),
    );
  }

  Widget _buildImagePickerButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: const Text('Upload Image from Gallery'),
        ),
        TextButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: const Text('Upload Image from Camera'),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  List<Widget> _buildEditCommunicationDialogActions(int communicationId, TextEditingController titleController) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () async {
          final title = titleController.text;
          if (title.isNotEmpty) {
            final authServices = Provider.of<Authservices>(context, listen: false);
            try {
              await authServices.editCommunication(
                communicationId,
                title,
                _selectedImagePath!,
              );
              fetchCommunications();
              Navigator.of(context).pop();
            } catch (error) {
              _showErrorSnackBar(error.toString());
            }
          }
        },
        child: const Text('Save'),
      ),
    ];
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
            child: AddCommunicationPage(),
          ),
        );
      },
    ).then((_) => fetchCommunications());
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminHeaderPage(),
      drawer: AdminDashboardDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.03,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedHeader(),
              SizedBox(height: 20),
              _buildCommunicationList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: showAddCommunicationDialog,
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Recent Communications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        );
      },
    );
  }

  Widget _buildCommunicationList() {
    return Column(
      children: communications.map((communication) {
        return _buildCommunicationCard(communication);
      }).toList(),
    );
  }

  Widget _buildCommunicationCard(Map<String, dynamic> communication) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "http://192.168.100.5:8000/${communication['location']}",
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Title: ${communication['title']}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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