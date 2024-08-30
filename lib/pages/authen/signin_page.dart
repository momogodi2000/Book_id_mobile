import 'package:cni/pages/authen/style/SigninAnimation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/auth_services.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;  // To show loading indicator

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SigninAnimation.buildHeaderImage(screenHeight, screenWidth),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.9,
                  decoration: SigninAnimation.buildContainerDecoration(),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SigninAnimation.buildTitle(screenWidth, 'Sign In'),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          label: 'Email',
                          obscureText: false,
                          onSaved: (value) => _email = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          label: 'Password',
                          obscureText: true,
                          onSaved: (value) => _password = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: SigninAnimation.buildTextButtonStyle(screenWidth),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()  // Show loading indicator if signing in
                            : ElevatedButton(
                          style: SigninAnimation.buildButtonStyle(screenWidth),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _signIn(context);
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: SigninAnimation.buildButtonTextStyle(screenWidth),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupPage()),
                            );
                          },
                          child: Text(
                            'Don\'t have an account? Sign Up',
                            style: SigninAnimation.buildLinkTextStyle(screenWidth),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required bool obscureText,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Future<void> _signIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Authservices>(context, listen: false).signin(
        _email,
        _password,
        context, // Pass the context here
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in successful!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}