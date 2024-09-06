import 'package:flutter/material.dart';
import '../reciept.dart';

class PaypalPaymentForm extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final TextEditingController bankNameController;
  final TextEditingController accountNumberController;
  final TextEditingController routingNumberController;

  const PaypalPaymentForm({
    Key? key,
    required this.fadeAnimation,
    required this.bankNameController,
    required this.accountNumberController,
    required this.routingNumberController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.02,
    );
    final textFieldHeight = size.height * 0.07;
    final _formKey = GlobalKey<FormState>();

    void _handleSubmit() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Simulate successful payment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment submitted successfully!")),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ReceiptPage(paymentData: {},)),
      );
    }

    return FadeTransition(
      opacity: fadeAnimation,
      child: Padding(
        padding: padding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PayPal Payment",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: textFieldHeight,
                child: TextFormField(
                  controller: bankNameController,
                  decoration: InputDecoration(
                    labelText: "Bank Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your bank name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: textFieldHeight,
                child: TextFormField(
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your account number";
                    }
                    if (!RegExp(r'^\d{8,17}$').hasMatch(value)) {
                      return "Please enter a valid account number";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: textFieldHeight,
                child: TextFormField(
                  controller: routingNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Routing Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your routing number";
                    }
                    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                      return "Please enter a valid routing number";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text("Submit Payment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3,
                    vertical: size.height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

