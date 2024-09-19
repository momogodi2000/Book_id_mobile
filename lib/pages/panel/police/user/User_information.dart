import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../models/police_models/User_models.dart';
import '../../../header/police_header.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  late Future<List<User>> users;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    users = Authservices().fetchUsers();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive layout
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      appBar: const PoliceHeaderPage(), // Custom header
      drawer: const PoliceDashboardDrawer(), // Custom drawer
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          // Responsive grid view based on device width
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2, // 1 column on mobile, 2 on larger screens
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isMobile ? 1 : 1.5, // Adjust card aspect ratio for larger screens
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return _buildUserCard(user, screenHeight, screenWidth);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(User user, double screenHeight, double screenWidth) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + _controller.value * 0.1,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  user.profilePicture.isNotEmpty
                      ? CircleAvatar(
                    radius: screenHeight * 0.06, // Responsive avatar size
                    backgroundImage: NetworkImage(user.profilePicture),
                  )
                      : CircleAvatar(
                    radius: screenHeight * 0.06, // Responsive default avatar size
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: screenHeight * 0.06, // Icon size relative to screen height
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(user.email, style: TextStyle(fontSize: screenWidth * 0.04)),
                  SizedBox(height: screenHeight * 0.005),
                  Text(user.phone, style: TextStyle(fontSize: screenWidth * 0.04)),
                  SizedBox(height: screenHeight * 0.005),
                  Text(user.address, style: TextStyle(fontSize: screenWidth * 0.04)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
