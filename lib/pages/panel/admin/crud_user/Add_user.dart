import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For File handling

class AddUserPage extends StatefulWidget {
  final VoidCallback onUserAdded;

  const AddUserPage({Key? key, required this.onUserAdded}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _role, _phone;
  File? _profileImage;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Method to capture an image from the camera
  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Profile Image Display
            Center(
              child: GestureDetector(
                onTap: () {
                  _showImagePickerDialog(context);
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15, // Responsive size
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                    Icons.add_a_photo,
                    size: MediaQuery.of(context).size.width * 0.15, // Responsive size
                    color: Colors.grey,
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Name Input
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => _name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),

            // Email Input
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (value) => _email = value,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: _role,
              decoration: InputDecoration(labelText: 'Role'),
              items: ['user', 'officer', 'admin']
                  .map((role) => DropdownMenuItem(
                value: role.toLowerCase(),
                child: Text(role),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _role = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a role';
                }
                return null;
              },
            ),

            // Phone Input
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone'),
              onSaved: (value) => _phone = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // Add User Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Implement API call to add the user with _profileImage, _name, _email, _role, _phone

                  // Call the onUserAdded callback
                  widget.onUserAdded();
                  Navigator.pop(context);
                }
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  // Image Picker Dialog to choose between Camera and Gallery
  void _showImagePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Capture from Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _captureImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}