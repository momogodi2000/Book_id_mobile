import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cni/Services/auth_services.dart';
import '../../../../models/police_models/User_models.dart';
import '../../../header/admin_header.dart';
import 'Add_user.dart';
import 'Edit_user.dart';
import 'Detail_user.dart'; // Import the DetailUserPage

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  List<User> _users = []; // List to hold fetched users
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Fetch users here
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await Authservices().fetchUsersFromApi(); // Fetch users from AuthServices
      setState(() {
        _users = users;
        _isLoading = false; // Set loading to false when done
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.85,
            child: AddUserPage(
              onUserAdded: _fetchUsers, // Refresh the user list after adding
            ),
          ),
        );
      },
    );
  }

  void _showDetailUserDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.85,
            child: DetailUserPage(
              userName: user.name,
              userRole: user.role,
              userEmail: user.email,
              userPhone: user.phone,
              userAddress: user.address,
              userImage: user.profilePicture.isNotEmpty
                  ? user.profilePicture
                  : 'assets/images/yvan.jpg', // Placeholder for profile picture
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteUser(String userIdString) async {
    int userId = int.parse(userIdString); // Convert userIdString to int
    try {
      // Replace with actual delete API method
      await Authservices().deleteUser(userId);
      _fetchUsers(); // Refresh the user list after deleting
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminHeaderPage(),
      drawer: AdminDashboardDrawer(),
      body: SlideTransition(
        position: _offsetAnimation,
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profilePicture.isNotEmpty
                      ? NetworkImage(user.profilePicture)
                      : AssetImage('assets/images/yvan.jpg') as ImageProvider, // Placeholder
                ),
                title: Text(user.name),
                subtitle: Text("Role: ${user.role}"),
                onTap: () {
                  _showDetailUserDialog(user); // Pass the user object
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to EditUserPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(
                              userId: int.parse(user.id), // Pass user ID as an int
                              onUserUpdated: _fetchUsers, // Refresh the user list after editing
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Confirm deletion
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete User'),
                              content: Text('Are you sure you want to delete this user?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                    _deleteUser(user.id); // Delete user
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Icon(Icons.add),
        tooltip: 'Add User',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
