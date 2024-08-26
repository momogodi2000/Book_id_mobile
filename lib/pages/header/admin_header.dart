import 'package:flutter/material.dart';

class HeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const HeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.1; // Adjust height as needed

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            // Handle search press
          },
        ),
        IconButton(
          icon: const Icon(Icons.wb_sunny_outlined, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Theme Settings'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.brightness_2, color: Colors.black),
                          title: const Text('Dark'),
                          onTap: () {
                            // Handle dark theme selection
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.brightness_7, color: Colors.black),
                          title: const Text('Light'),
                          onTap: () {
                            // Handle light theme selection
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings_brightness, color: Colors.black),
                          title: const Text('Default'),
                          onTap: () {
                            // Handle default theme selection
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Settings'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profil'),
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(),));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Parametre'),
                          onTap: () {
                            // Handle Parametre settings
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.support_agent),
                          title: const Text('Support'),
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage(),));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Se Deconnecter'),
                          onTap: () {
                            // Handle Logout
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      toolbarHeight: appBarHeight, // Set AppBar height
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Drawer for Admin Dashboard
class AdminDashboardDrawer extends StatelessWidget {
  const AdminDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _createDrawerItem(
                  icon: Icons.group,
                  text: 'Manage Users',
                  onTap: () {
                    // Handle manage users
                  },
                ),
                _createDrawerItem(
                  icon: Icons.document_scanner,
                  text: 'Manage Documents',
                  onTap: () {
                    // Handle manage documents
                  },
                ),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    // Handle settings
                  },
                ),
                _createDrawerItem(
                  icon: Icons.info_outline,
                  text: 'About Us',
                  onTap: () {
                    // Handle about us
                  },
                ),
                _createDrawerItem(
                  icon: Icons.publish,
                  text: 'Publication',
                  onTap: () {
                    // Handle publication
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

// Main Scaffold Widget with Header and Drawer
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPage(),
      drawer: const AdminDashboardDrawer(),
      body: Center(
        child: Text('Main Content Area'),
      ),
    );
  }
}
