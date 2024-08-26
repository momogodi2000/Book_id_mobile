import 'package:flutter/material.dart';
import 'Detail_user.dart';
import 'add_user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _users = [
    {'username': 'JohnDoe', 'email': 'john@example.com', 'role': 'User'},
    {'username': 'JaneDoe', 'email': 'jane@example.com', 'role': 'Admin'},
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: FadeTransition(
        opacity: _animation,
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.05),
              elevation: 4,
              child: ListTile(
                title: Text(
                  user['username'] ?? 'Unknown', // Safe access
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${user['email'] ?? 'No email'}\nRole: ${user['role'] ?? 'No role'}' // Safe access
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      _showUserFormDialog(user: user);
                    } else if (value == 'Delete') {
                      setState(() {
                        _users.removeAt(index);
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: user),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserFormDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserFormDialog({Map<String, String>? user}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: UserFormPage(user: user),
      ),
    );
  }
}
