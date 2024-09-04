import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Services/auth_services.dart';
import '../reciept.dart';

class MobilePaymentForm extends StatefulWidget {
  final Animation<double> fadeAnimation;
  final TextEditingController mobileController;

  const MobilePaymentForm({
    Key? key,
    required this.fadeAnimation,
    required this.mobileController,
  }) : super(key: key);

  @override
  _MobilePaymentFormState createState() => _MobilePaymentFormState();
}

class _MobilePaymentFormState extends State<MobilePaymentForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the mobile controller with the default code +237
    widget.mobileController.text = '+237';
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Handle payment submission
    try {
      final authService = Provider.of<Authservices>(context, listen: false);
      final phone = widget.mobileController.text;
      final userId = "user-id"; // Replace with actual user ID or handle accordingly

      await authService.submitPayment(phone, userId);

      // If payment is successful, show a success message and redirect to ReceiptPage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment submitted successfully!")),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ReceiptPage()),
        );
      });
    } catch (error) {
      // Show an error message if payment submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred during payment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.02,
    );

    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: Padding(
        padding: padding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mobile Payment",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: widget.mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile phone number";
                  }
                  // Validate that the phone number starts with '6' and is 9 digits long
                  if (!RegExp(r'^\+2376\d{8}$').hasMatch(value)) {
                    return "Please enter a valid phone number starting with 6";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitPayment,
                child: Text("Submit Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
