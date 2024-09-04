import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Receipt",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20.0),
            // Add receipt details here
            Text(
              "Thank you for your payment. Your transaction has been successfully processed.",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            // You can add more details or options for downloading the receipt
          ],
        ),
      ),
    );
  }
}
