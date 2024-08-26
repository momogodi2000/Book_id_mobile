import 'package:flutter/material.dart';

class MakePaymentPage extends StatefulWidget {
  @override
  _MakePaymentPageState createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage>
    with SingleTickerProviderStateMixin {
  String? _selectedPaymentMethod; // To store the selected payment method
  final _formKey = GlobalKey<FormState>(); // Key for the form
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _routingNumberController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _mobileController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment submitted successfully!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Make Payment"),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a Payment Method",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              ListTile(
                title: Text("Mobile Payment"),
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
                title: Text("PayPal Payment"),
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
              const SizedBox(height: 20.0),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: _selectedPaymentMethod == null
                        ? Container()
                        : _selectedPaymentMethod == "mobile"
                        ? _buildMobilePaymentForm(isPortrait)
                        : _buildPaypalPaymentForm(isPortrait),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  child: Text("Submit Payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mobile Payment Form
  Widget _buildMobilePaymentForm(bool isPortrait) {
    return FadeTransition(
      opacity: _fadeAnimation!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mobile Payment",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Mobile Phone Number",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your mobile phone number";
              }
              if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                return "Please enter a valid phone number";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // PayPal Payment Form
  Widget _buildPaypalPaymentForm(bool isPortrait) {
    return FadeTransition(
      opacity: _fadeAnimation!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PayPal Payment",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _bankNameController,
            decoration: InputDecoration(
              labelText: "Bank Name",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your bank name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Account Number",
              border: OutlineInputBorder(),
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
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _routingNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Routing Number",
              border: OutlineInputBorder(),
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
        ],
      ),
    );
  }
}
