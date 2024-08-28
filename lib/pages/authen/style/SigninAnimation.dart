import 'package:flutter/material.dart';

class SigninAnimation {
  static Widget buildHeaderImage(double screenHeight, double screenWidth) {
    return Image.asset(
      'assets/images/auth.jpeg',
      height: screenHeight * 0.15,
      width: screenWidth * 0.3,
    );
  }

  static BoxDecoration buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8.0,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  static Widget buildTitle(double screenWidth, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth * 0.06,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  static TextStyle buildTextButtonStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.04,
      color: Colors.blue,
    );
  }

  static ButtonStyle buildButtonStyle(double screenWidth) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  static TextStyle buildButtonTextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.05,
    );
  }

  static TextStyle buildLinkTextStyle(double screenWidth) {
    return TextStyle(
      color: Colors.blue,
      fontSize: screenWidth * 0.04,
      decoration: TextDecoration.underline,
    );
  }
}
