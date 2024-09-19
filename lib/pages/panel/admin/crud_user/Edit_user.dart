import 'dart:io';
import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUserPage extends StatefulWidget {
  final int userId;
  final VoidCallback onUserUpdated;

  EditUserPage({required this.userId, required this.onUserUpdated});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _role, _phone;
  File? _profileImage;
  bool _isLoading = true;
  final _picker = ImagePicker();
  late Authservices _authService;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _authService = Authservices as Authservices; // Update with your actual API URL
    _fetchUsersFromApi(widget.userId);

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _fetchUsersFromApi(int userId) async {
    try {
      final userData = await _authService.fetchUserDetailsFromApi(userId);
      setState(() {
        _name = userData['name'];
        _email = userData['email'];
        _role = userData['role'];
        _phone = userData['phone'];
        _profileImage = userData['profile_picture'] != null
            ? File(userData['profile_picture'])
            : null;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching user details: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      await _authService.updateUser(
        widget.userId,
        _name!,
        _email!,
        _role!,
        _phone!,
        _profileImage,
      );
      widget.onUserUpdated();
      Navigator.pop(context);
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: _isLoading
          ? Center(
        child: FadeTransition(
          opacity: _animation,
          child: CircularProgressIndicator(),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: isMobile ? 60 : 80,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, size: isMobile ? 60 : 80)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                initialValue: _name,
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
                initialValue: _email,
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
                items: ['User', 'Police Officer', 'Admin']
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
                initialValue: _phone,
                onSaved: (value) => _phone = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}