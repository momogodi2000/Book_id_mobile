import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManageComDialog extends StatefulWidget {
  final bool isEditing;

  const ManageComDialog({super.key, required this.isEditing});

  @override
  _ManageComDialogState createState() => _ManageComDialogState();
}

class _ManageComDialogState extends State<ManageComDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.isEditing ? 'Edit Communication' : 'Add Communication',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _imageFile == null
                    ? Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take a Photo'),
                    ),
                  ],
                )
                    : Image.file(
                  File(_imageFile!.path),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.isEditing ? 'Save Changes' : 'Add Communication'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      if (isValidImageFormat(pickedFile.path)) {
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        _showErrorDialog('Invalid format. Please select a clear photo in JPG, JPEG, or PNG format.');
      }
    }
  }

  bool isValidImageFormat(String path) {
    final validFormats = ['jpg', 'jpeg', 'png'];
    final extension = path.split('.').last.toLowerCase();
    return validFormats.contains(extension);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        // Process the communication
        Navigator.of(context).pop();
      } else {
        _showErrorDialog('Please add a photo.');
      }
    }
  }
}
