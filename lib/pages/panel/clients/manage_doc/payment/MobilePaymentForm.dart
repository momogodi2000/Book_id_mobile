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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    widget.mobileController.text = '';  // Initialize empty
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;  // Set loading state
    });

    try {
      final authService = Provider.of<Authservices>(context, listen: false);
      final phone = widget.mobileController.text; // Phone number without country code
      final userId = (await authService.getCurrentUserId()).toString();  // Get actual user ID

      // Submit payment via the auth service
      final response = await authService.submitPayment(phone);  // Send phone number only

      // Check if payment was successful
      if (response['status'] == 'SUCCESSFUL') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful! Reference: ${response['reference']}")),
        );

        // Redirect to ReceiptPage with payment details
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ReceiptPage(paymentData: response),
            ),
          );
        });
      } else {
        // Handle payment failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment failed: ${response['message']}")),
        );
      }
    } catch (error) {
      // Handle any errors during the payment process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during payment: $error")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;  // Reset loading state
      });
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: widget.mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 9,  // Limit to 9 digits
                decoration: InputDecoration(
                  labelText: "Mobile Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  counterText: '',  // Hide the counter text
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile phone number";
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                    return "Please enter a valid 9-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              if (_isSubmitting)
                const Center(child: CircularProgressIndicator())
              else
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