import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking from gallery or camera
import 'dart:io';

class AddIdCardPage extends StatefulWidget {
  const AddIdCardPage({super.key});

  @override
  _AddIdCardPageState createState() => _AddIdCardPageState();
}

class _AddIdCardPageState extends State<AddIdCardPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _phone;
  File? _idCardImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _idCardImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveIdCard() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save to database logic here
      print('Name: $_name, Email: $_email, Phone: $_phone, Image: $_idCardImage');
      Navigator.pop(context, true); // Return to previous page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Missing ID Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                onSaved: (value) => _phone = value,
              ),
              const SizedBox(height: 20),
              _idCardImage == null
                  ? const Text('No image selected.')
                  : Image.file(_idCardImage!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveIdCard,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
