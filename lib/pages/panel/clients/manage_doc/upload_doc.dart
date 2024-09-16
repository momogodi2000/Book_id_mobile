import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../../header/clients_header.dart';
import 'book_appointment.dart';


class UploadDocPage extends StatefulWidget {
  const UploadDocPage({super.key});

  @override
  _UploadDocPageState createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> with SingleTickerProviderStateMixin {
  final List<File?> _documents = List<File?>.filled(6, null);
  final _picker = ImagePicker();

  final List<String> allowedFormats = ["pdf", "jpg", "jpeg", "png"];
  final List<String> _documentNames = [
    "Birth Certificate",
    "Proof of Nationality",
    "Criminal Record Extract",
    "Residence Permit",
    "Marriage Certificate",
    "Worker / Students",
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  Future<void> _pickDocument(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final fileExtension = pickedFile.path.split('.').last.toLowerCase();

      if (allowedFormats.contains(fileExtension)) {
        setState(() {
          _documents[index] = File(pickedFile.path);
          _controller.forward(from: 0.0);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unsupported format, please select a PDF, JPG, JPEG, or PNG file."),
          ),
        );
      }
    }
  }

  bool _validateFiles() {
    return _documents.every((doc) => doc != null);
  }

  Future<void> _submitDocuments() async {
    if (_validateFiles()) {
      final authService = Provider.of<Authservices>(context, listen: false);
      try {
        final documentsMap = {
          'birth_certificate': _documents[0],
          'proof_of_nationality': _documents[1],
          'passport_photos': _documents[2],
          'residence_permit': _documents[3],
          'marriage_certificate': _documents[4],
          'death_certificate': _documents[5],
        };

        await authService.uploadDocuments(documentsMap);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Documents uploaded successfully!"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookAppointmentPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload all required documents."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(),
      drawer: const ClientDashboardDrawer(),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Insert your national legalized documents.",
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _documents.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _documentNames[index],
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () => _pickDocument(index, ImageSource.camera),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.photo_library),
                                    onPressed: () => _pickDocument(index, ImageSource.gallery),
                                  ),
                                ],
                              ),
                              _documents[index] != null
                                  ? FadeTransition(
                                opacity: _animation,
                                child: Container(
                                  height: isPortrait ? 100 : 80,
                                  width: isPortrait ? 80 : 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: FileImage(_documents[index]!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                                  : const Text(
                                "No document",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue, // Changed to blue
                ),
                onPressed: _submitDocuments,
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: size.width * 0.045),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}