import 'package:flutter/material.dart';
import 'package:cni/pages/panel/clients/manage_doc/payment/MobilePaymentForm.dart';
import 'package:cni/pages/panel/clients/manage_doc/payment/PaypalPaymentForm.dart';

class MakePaymentPage extends StatefulWidget {
  const MakePaymentPage({super.key});

  @override
  _MakePaymentPageState createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage>
    with SingleTickerProviderStateMixin {
  String? _selectedPaymentMethod;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _routingNumberController = TextEditingController();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mobileController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment submitted successfully!"),
        ),
      );
      // Optionally clear form or perform additional actions
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.03,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Payment"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a Payment Method",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 20.0),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: _selectedPaymentMethod == null
                      ? Container()
                      : _selectedPaymentMethod == "mobile"
                      ? MobilePaymentForm(
                    fadeAnimation: _fadeAnimation,
                    mobileController: _mobileController,
                  )
                      : PaypalPaymentForm(
                    fadeAnimation: _fadeAnimation,
                    bankNameController: _bankNameController,
                    accountNumberController: _accountNumberController,
                    routingNumberController: _routingNumberController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        ListTile(
          title: const Text("Mobile Payment"),
          leading: Radio<String>(
            value: "mobile",
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text("PayPal Payment"),
          leading: Radio<String>(
            value: "paypal",
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
