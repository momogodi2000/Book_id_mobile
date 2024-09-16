import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/auth_services.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';
  String _newPassword = '';
  bool _isCodeValid = false;
  int _timer = 60; // 1 minute timer
  late DateTime _codeSentTime;

  @override
  void initState() {
    super.initState();
    _codeSentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
        _startTimer();
      } else {
        setState(() {
          _isCodeValid = false; // Code is no longer valid after 60 seconds
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Enter Code and New Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the verification code';
                        } else if (!_isCodeValid) {
                          return 'Code is invalid or expired';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _code = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newPassword = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Call API to change password using the verification code and new password
                          try {
                            await Provider.of<Authservices>(context, listen: false)
                                .changePassword(widget.email, _code, _newPassword);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password changed successfully!')),
                            );
                            Navigator.pop(context); // Go back to Sign In
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          }
                        }
                      },
                      child: const Text('Change Password', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Code valid for: $_timer seconds',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}