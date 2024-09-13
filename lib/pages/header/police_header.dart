import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/auth_services.dart';
import '../../language/change_language.dart';
import '../../provider/ThemeNotifier.dart';
import '../panel/police/communication/view_com.dart';
import '../panel/police/manage_appointment/Appointments_list.dart';
import '../panel/police/missing_doc/find_id.dart';
import '../panel/clients/missing_doc/upload_id.dart';
import '../panel/clients/setting/logout.dart';
import '../panel/clients/setting/profile.dart';
import '../panel/clients/setting/support.dart';
import '../panel/police/contact/contact_us_management.dart';
import '../panel/police/police_panel.dart';
import '../panel/police/user/User_information.dart';

class PoliceHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const PoliceHeaderPage({super.key});


  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.1;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
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
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () => _showSettingsDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.wb_sunny_outlined, color: Colors.black),
          onPressed: () => _showThemeSettingsDialog(context),
        ),
      ],
      toolbarHeight: appBarHeight,
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _settingsListTile(context, Icons.person, 'Profile', const ProfilePage()),
                _settingsListTile(context, Icons.language, 'Language',  ChangeLanguagePage()),
                _settingsListTile(context, Icons.support_agent, 'Support', const SupportPage()),
                _settingsListTile(context, Icons.logout, 'Log Out', const LogoutPage()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  ListTile _settingsListTile(BuildContext context, IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (isLogout) {
          Authservices().logout();
          Navigator.of(context).pop();
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }

  void _showThemeSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Theme Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _themeListTile(context, Icons.brightness_2, 'Dark', (themeNotifier) => themeNotifier.setDarkTheme()),
                _themeListTile(context, Icons.brightness_7, 'Light', (themeNotifier) => themeNotifier.setLightTheme()),
                _themeListTile(context, Icons.settings_brightness, 'Default', (themeNotifier) => themeNotifier.setDefaultTheme()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  ListTile _themeListTile(BuildContext context, IconData icon, String title, Function(ThemeNotifier) onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
        onTap(themeNotifier);
        Navigator.of(context).pop();
      },
    );
  }







  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PoliceDashboardDrawer extends StatelessWidget {
  const PoliceDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              children: _buildDrawerItems(context),
            ),
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text('John'),
      accountEmail: Text('john@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        backgroundImage: AssetImage('assets/images/yvan.jpg'),
      ),
      decoration: BoxDecoration(color: Colors.blueGrey),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return [
      _createDrawerItem(context, Icons.dashboard, 'Dashboard', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PolicePanelPage()));
      }),
      _createDrawerItem(context, Icons.calendar_today, 'Manage Appointments', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>AppointmentsPage()));
      }),
      _createDrawerItem(context, Icons.card_membership, 'Manage Missing ID Card', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FindIDPage()));
      }),
      _createDrawerItem(context, Icons.person, 'User Information', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserPage()));

      }),
      _createDrawerItem(context, Icons.contact_support, 'Contact Us', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  ContactUsPage()));
      }),
      _createDrawerItem(context, Icons.card_giftcard, 'Card Availability', () {
        // Handle card availability
      }),
      _createDrawerItemWithDropdown(context, Icons.public, 'Publication', [
        _createDropdownItem(context, Icons.note, 'Note', () {
          // Handle note
        }),
        _createDropdownItem(context, Icons.message, 'Communication', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunicationPage()));
        }),
      ]),
    ];
  }

  Widget _createDrawerItem(BuildContext context, IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _createDrawerItemWithDropdown(BuildContext context, IconData icon, String text, List<Widget> dropdownItems) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(text),
      children: dropdownItems,
    );
  }

  Widget _createDropdownItem(BuildContext context, IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 18),
      title: Text(text),
      onTap: onTap,
    );
  }
}