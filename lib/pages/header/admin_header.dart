import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ThemeNotifier.dart';
import '../panel/admin/about_us/about_us.dart';
import '../panel/admin/admin_panel.dart';
import '../panel/admin/communication/view_com.dart';
import '../panel/admin/contact/contact_us_management.dart';
import '../panel/admin/crud_user/User_information.dart';
import '../panel/admin/manage Document/doc_admin.dart';
import '../panel/admin/manage Document/document_page.dart';
import '../panel/admin/map/near_by_police.dart';
import '../panel/admin/statistic/statistics_page.dart';
import '../panel/clients/setting/logout.dart';

class AdminHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const AdminHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final appBarHeight = MediaQuery.of(context).size.height * 0.1; // Responsive height

    return AppBar(
      backgroundColor: themeNotifier.theme.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: themeNotifier.theme.iconTheme.color),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: _buildAppBarActions(context, themeNotifier),
      toolbarHeight: appBarHeight,
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, ThemeNotifier themeNotifier) {
    return [
      IconButton(
        icon: Icon(Icons.search, color: themeNotifier.theme.iconTheme.color),
        onPressed: () {
          // Handle search action
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
    ];
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context,
        title: 'Settings',
        items: [
          _createSettingsItem(Icons.person, 'Profile', () {
            // Handle profile tap
          }),
          _createSettingsItem(Icons.language, 'Language', () {
            // Handle language tap
          }),
          _createSettingsItem(Icons.logout, 'Log Out', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LogoutPage()));
          }),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context,
        title: 'Theme Settings',
        items: [
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
    );
  }

  Widget _buildDialog(BuildContext context, {required String title, required List<Widget> items}) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
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
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class AdminDashboardDrawer extends StatelessWidget {
  const AdminDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.75;
    final avatarRadius = MediaQuery.of(context).size.width * 0.1;
    final userName = "John"; // Replace with actual logic to get the user's name

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const AssetImage('assets/images/yvan.jpg'), // Replace with actual path
                ),
                const SizedBox(width: 16),
                Text(
                  'Welcome, $userName!',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildDrawerItems(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return [
      _createDashboardItem(context),
      _createDrawerItem(Icons.group, 'Manage Users', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserListPage()));
      }),
      _createDrawerItem(Icons.document_scanner, 'Manage Documents', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  StatisticDoc()));
      }),
      _createDrawerItem(Icons.contact_page, 'Manage Contact Messages', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  ContactUsPage()));

      }),
      _createDrawerItem(Icons.map, 'Police Map', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  NearbyPoliceStationsPage()));

      }),
      _createDrawerItem(Icons.info_outline, 'About Us', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
      }),
      _createDrawerItem(Icons.publish, 'Communication', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunicationPage()));

      }),
    ];
  }

  Widget _createDashboardItem(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.dashboard),
      title: const Text('Dashboard'),
      children: [
        _createDrawerItem(Icons.bar_chart, 'Statistics', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));

        }),
        _createDrawerItem(Icons.dashboard, 'Dashboard', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanelPage()));
        }),
      ],
    );
  }

  Widget _createDrawerItem(IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}