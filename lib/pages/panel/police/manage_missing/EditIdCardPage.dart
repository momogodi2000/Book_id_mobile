import 'package:flutter/material.dart';
import 'dart:io';
import 'ViewIdCardsPage.dart';

class EditIdCardPage extends StatefulWidget {
  final IdCard idCard;

  const EditIdCardPage({super.key, required this.idCard});

  @override
  _EditIdCardPageState createState() => _EditIdCardPageState();
}

class _EditIdCardPageState extends State<EditIdCardPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _phone;
  File? _idCardImage;

  @override
  void initState() {
    super.initState();
    _name = widget.idCard.name;
    _email = widget.idCard.email;
    _phone = widget.idCard.phone;
    // Load the initial image
  }

  void _updateIdCard() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update in database logic here
      print('Updated Name: $_name, Email: $_email, Phone: $_phone, Image: $_idCardImage');
      Navigator.pop(context, true); // Return to previous page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Missing ID Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                onSaved: (value) => _phone = value,
              ),
              const SizedBox(height: 20),
              _idCardImage == null
                  ? const Text('No image selected.')
                  : Image.file(_idCardImage!),
              ElevatedButton(
                onPressed: _updateIdCard,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
