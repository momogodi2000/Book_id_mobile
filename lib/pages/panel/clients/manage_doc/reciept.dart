import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const ReceiptPage({Key? key, required this.paymentData}) : super(key: key);

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Payment Receipt',
                style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              ...paymentData.entries.map((entry) {
                return pw.Text(
                  '${entry.key}: ${entry.value}',
                  style: const pw.TextStyle(fontSize: 12),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    // Save and share the PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'payment_receipt.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Receipt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...paymentData.entries.map((entry) {
              return Text(
                "${entry.key}: ${entry.value}",
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generatePdf,
              child: const Text("Download Receipt as PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
