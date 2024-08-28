import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ThemeNotifier.dart';
import '../panel/admin/about_us/about_us.dart';
import '../panel/admin/crud_user/view_user.dart';
import '../panel/clients/setting/logout.dart';

class AdminHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const AdminHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.1; // Responsive height
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return AppBar(
      backgroundColor: themeNotifier.theme.primaryColor, // Use the current theme's primary color
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: themeNotifier.theme.iconTheme.color),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: themeNotifier.theme.iconTheme.color),
          onPressed: () {
            // Handle search press
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: themeNotifier.theme.iconTheme.color),
          onPressed: () => _showSettingsDialog(context),
        ),
        IconButton(
          icon: Icon(Icons.wb_sunny_outlined, color: themeNotifier.theme.iconTheme.color),
          onPressed: () => _showThemeDialog(context),
        ),
      ],
      toolbarHeight: appBarHeight, // Responsive AppBar height
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createSettingsItem(Icons.person, 'Profile', () {
                  // Handle profile tap
                }),
                _createSettingsItem(Icons.language, 'Language', () {
                  // Handle language tap
                }),
                _createSettingsItem(Icons.logout, 'Log Out', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogoutPage()),
                  );
                }),
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
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createThemeItem(Icons.brightness_2, 'Dark', () {
                  Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
                }),
                _createThemeItem(Icons.brightness_4_rounded, 'Light', () {
                  Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
                }),
                _createThemeItem(Icons.settings_brightness, 'Default', () {
                  Provider.of<ThemeNotifier>(context, listen: false).setDefaultTheme();
                }),
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
  }

  Widget _createSettingsItem(IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _createThemeItem(IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey), // Icon color can be styled
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // Fixed height, or adjust as needed
}

class AdminDashboardDrawer extends StatelessWidget {
  const AdminDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    double avatarRadius = MediaQuery.of(context).size.width * 0.1;
    String userName = "John"; // Replace with actual logic to get the user's name

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const AssetImage('assets/images/yvan.jpg'), // Replace with the actual path
                ),
                const SizedBox(width: 16),
                Text(
                  'Welcome, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _createDashboardItem(context),
                _createDrawerItem(
                  icon: Icons.group,
                  text: 'Manage Users',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserListPage()),
                    );
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
                  icon: Icons.info_outline,
                  text: 'About Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
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

  Widget _createDashboardItem(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.dashboard),
      title: const Text('Dashboard'),
      children: [
        _createDrawerItem(
          icon: Icons.bar_chart,
          text: 'Statistics',
          onTap: () {
            // Handle statistics action
          },
        ),
        _createDrawerItem(
          icon: Icons.analytics,
          text: 'Analysis',
          onTap: () {
            // Handle analysis action
          },
        ),
      ],
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}