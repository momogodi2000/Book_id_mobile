import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'crud_contact_us.dart';


class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  List<dynamic> contactUsMessages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContactUsMessages();
  }

  Future<void> fetchContactUsMessages() async {
    final contactUsService = Provider.of<Authservices>(context, listen: false);
    try {
      final messages = await contactUsService.fetchContactUsMessages();
      setState(() {
        contactUsMessages = messages;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching contact us messages: $error');
    }
  }

  void handleManageMessage(BuildContext context, Map<String, dynamic> message) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CrudContactUsPage(message: message),
      ),
    );

    if (result == true) {
      fetchContactUsMessages(); // Refresh the list if a message was deleted
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us Messages'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildMessageList(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Received Messages',
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(double screenHeight, double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: contactUsMessages.length,
      itemBuilder: (context, index) {
        final message = contactUsMessages[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: ListTile(
            title: Text(message['name']),
            subtitle: Text(message['message']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.reply, color: Colors.blueAccent),
                  onPressed: () => handleManageMessage(context, message),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => handleManageMessage(context, message),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
