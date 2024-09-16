import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../models/police_models/User_models.dart';

class AddUserPage extends StatefulWidget {
  final VoidCallback onUserAdded;

  const AddUserPage({Key? key, required this.onUserAdded}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _role, _phone, _address;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a user object
      User newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a temporary ID
        name: _name!,
        email: _email!,
        role: _role!,
        phone: _phone!,
        address: _address ?? 'No Address', // Default address if not provided
        profilePicture: _profileImage?.path ?? '', // Use path or handle upload
      );

      try {
        await Authservices().addUser(newUser);
        widget.onUserAdded();
        Navigator.pop(context);
      } catch (error) {
        print('Error adding user: $error');
      }
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
            Center(
              child: GestureDetector(
                onTap: () {
                  _showImagePickerDialog(context);
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                    Icons.add_a_photo,
                    size: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.grey,
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),

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

            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              onSaved: (value) => _address = value,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _addUser,
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

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