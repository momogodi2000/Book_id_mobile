import 'package:flutter/material.dart';

class DetailMissingPage extends StatelessWidget {
  final dynamic idCard;

  const DetailMissingPage({Key? key, required this.idCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        height: screenHeight * 0.6,
        width: screenWidth * 0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details of Found ID',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Found by: ${idCard['name']}',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              Text(
                'Date Found: ${idCard['date_found']}',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              Text(
                'Contact: ${idCard['phone']}',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              Text(
                'Email: ${idCard['email']}',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.02),
              Image.network(
                'http://192.168.1.173:8000${idCard['id_card_image']}', // Adjust the URL as needed
                height: screenHeight * 0.25,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}