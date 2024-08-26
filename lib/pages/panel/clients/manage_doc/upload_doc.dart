import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocPage extends StatefulWidget {
  @override
  _UploadDocPageState createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  final List<File?> _documents = List<File?>.filled(5, null);
  final _picker = ImagePicker();
  final List<String> allowedFormats = ["pdf", "jpg", "jpeg", "png"]; // Allowed formats

  // Function to pick a document
  Future<void> _pickDocument(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final fileExtension = pickedFile.path.split('.').last.toLowerCase();

      if (allowedFormats.contains(fileExtension)) {
        setState(() {
          _documents[index] = File(pickedFile.path);
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

  // Function to validate all files before submission
  bool _validateFiles() {
    for (var doc in _documents) {
      if (doc == null) {
        return false;
      }
    }
    return true;
  }

  // Function to submit files
  void _submitDocuments() {
    if (_validateFiles()) {
      // Upload documents to the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Documents successfully submitted!"),
        ),
      );
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
      appBar: AppBar(
        title: const Text("Upload Documents"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Insert your national legalized documents.",
              style: TextStyle(
                fontSize: 18.0,
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Document ${index + 1}",
                                style: const TextStyle(fontSize: 18.0),
                              ),
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
                            ],
                          ),
                          if (_documents[index] != null)
                            Container(
                              height: isPortrait ? 150 : 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: FileImage(_documents[index]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                onPressed: _submitDocuments,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
