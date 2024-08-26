import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsManagementPage extends StatefulWidget {
  const ContactUsManagementPage({super.key});

  @override
  _ContactUsManagementPageState createState() => _ContactUsManagementPageState();
}

class _ContactUsManagementPageState extends State<ContactUsManagementPage> {
  List<ContactUsMessage> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse('http://your_backend_api/get_contact_us_messages'));
    if (response.statusCode == 200) {
      setState(() {
        messages = (json.decode(response.body) as List)
            .map((data) => ContactUsMessage.fromJson(data))
            .toList();
      });
    }
  }

  Future<void> deleteMessage(int id) async {
    final response = await http.delete(Uri.parse('http://your_backend_api/delete_contact_us_message/$id'));
    if (response.statusCode == 200) {
      setState(() {
        messages.removeWhere((msg) => msg.id == id);
      });
    }
  }

  Future<void> replyMessage(int id, String reply) async {
    final response = await http.post(
      Uri.parse('http://your_backend_api/reply_contact_us_message/$id'),
      body: {'reply_message': reply},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent successfully')));
    }
  }

  void showReplyDialog(ContactUsMessage message) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to ${message.name}'),
        content: TextField(
          controller: replyController,
          decoration: const InputDecoration(hintText: 'Enter your reply here'),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              replyMessage(message.id, replyController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Contact Us Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(message.name),
              subtitle: Text('Email: ${message.email}\nMessage: ${message.message}\nDate: ${message.createdAt}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.reply),
                    onPressed: () => showReplyDialog(message),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteMessage(message.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContactUsMessage {
  final int id;
  final String name;
  final String email;
  final String message;
  final String createdAt;

  ContactUsMessage({required this.id, required this.name, required this.email, required this.message, required this.createdAt});

  factory ContactUsMessage.fromJson(Map<String, dynamic> json) {
    return ContactUsMessage(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}
