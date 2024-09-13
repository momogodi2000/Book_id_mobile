import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrudContactUsPage extends StatefulWidget {
  final Map<String, dynamic> message;

  CrudContactUsPage({required this.message});

  @override
  _CrudContactUsPageState createState() => _CrudContactUsPageState();
}

class _CrudContactUsPageState extends State<CrudContactUsPage> with SingleTickerProviderStateMixin {
  final TextEditingController replyController = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    replyController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> handleDelete(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final contactUsService = Provider.of<Authservices>(context, listen: false);

    try {
      await contactUsService.deleteContactUsMessage(widget.message['id']);
      Navigator.of(context).pop(true); // Return true to indicate successful deletion
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error deleting contact us message: $error');
    }
  }

  Future<void> handleReply(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final contactUsService = Provider.of<Authservices>(context, listen: false);

    try {
      await contactUsService.replyToContactUsMessage(
        widget.message['id'], // Use the message ID for the reply
        replyController.text,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(); // Go back after replying
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error replying to contact us message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Message'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : FadeTransition(
          opacity: _animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${widget.message['name']}',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Email: ${widget.message['email']}',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Message: ${widget.message['message']}',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Reply:',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: replyController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your reply here...',
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => handleDelete(context),
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => handleReply(context),
                    icon: Icon(Icons.send),
                    label: Text('Reply'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}