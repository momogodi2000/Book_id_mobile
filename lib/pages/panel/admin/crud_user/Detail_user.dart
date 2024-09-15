import 'package:flutter/material.dart';

class DetailUserPage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String userImage;

  DetailUserPage({
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.85, // Responsive width
        height: MediaQuery.of(context).size.height * 0.6, // Responsive height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Image
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(userImage),
            ),
            SizedBox(height: 20),

            // User Name
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // User Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),

            // User Role
            Text(
              "Role: $userRole",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),

            // Buttons (optional for further actions)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
