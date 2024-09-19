import 'package:flutter/material.dart';
import 'package:animations/animations.dart'; // For animations

class DetailUserPage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String userImage;
  final String userPhone;
  final String userAddress;

  DetailUserPage({
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.userImage,
    required this.userPhone,
    required this.userAddress,
  });

  @override
  Widget build(BuildContext context) {
    // Media query for responsive layout
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isMobile = screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        width: isMobile ? screenWidth * 0.9 : screenWidth * 0.6, // Responsive width
        height: isMobile ? screenHeight * 0.75 : screenHeight * 0.65, // Responsive height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Image with animation
            Hero(
              tag: 'userImage',
              child: CircleAvatar(
                radius: isMobile ? 40 : 50,
                backgroundImage: AssetImage(userImage),
              ),
            ),
            SizedBox(height: isMobile ? 10 : 20),

            // User Name with animation
            OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 500),
              openBuilder: (context, action) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(userName),
                  ),
                  body: Center(child: Text('More details about $userName')),
                );
              },
              closedBuilder: (context, action) {
                return Text(
                  userName,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 10),

            // User Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),

            // User Phone
            Text(
              "Phone: $userPhone",
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),

            // User Role
            Text(
              "Role: $userRole",
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            // User Address
            Text(
              "Address: $userAddress",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isMobile ? 20 : 30),

            // Close Button with animation
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
