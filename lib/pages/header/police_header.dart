import 'package:flutter/material.dart';

import '../panel/police/communication/add_com.dart';

class PoliceHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const PoliceHeaderPage({super.key});

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
                          title: const Text('Profile'),
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            // Handle navigation to ProfilePage
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            // Handle settings
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.support_agent),
                          title: const Text('Support'),
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            // Handle navigation to SupportPage
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
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

// Drawer for Police Dashboard
class PoliceDashboardDrawer extends StatelessWidget {
  const PoliceDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Police Dashboard',
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
                  icon: Icons.event_available,
                  text: 'Manage Appointments',
                  onTap: () {
                    // Handle manage appointments
                  },
                ),
                _createDrawerItem(
                  icon: Icons.person_search,
                  text: 'User Information',
                  onTap: () {
                    // Handle user information
                  },
                ),
                _createDrawerItem(
                  icon: Icons.notifications,
                  text: 'Notifications',
                  onTap: () {
                    // Handle notifications
                  },
                ),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    // Handle settings
                  },
                ),
                _createDrawerItemWithDropdown(
                  icon: Icons.public,
                  text: 'Publication',
                  dropdownItems: [
                    _createDropdownItem(
                      icon: Icons.note,
                      text: 'Note',
                      onTap: () {
                        // Handle note
                      },
                    ),
                    _createDropdownItem(
                      icon: Icons.message,
                      text: 'Communication',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddComPage()),
                        );
                      },
                    ),
                  ],
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

  Widget _createDrawerItemWithDropdown({
    required IconData icon,
    required String text,
    required List<Widget> dropdownItems,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(text),
      children: dropdownItems,
    );
  }

  Widget _createDropdownItem({required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, size: 18),
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
class PoliceMainPage extends StatelessWidget {
  const PoliceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PoliceHeaderPage(),
      drawer: const PoliceDashboardDrawer(),
      body: Center(
        child: Text('Police Dashboard Main Content Area'),
      ),
    );
  }
}
