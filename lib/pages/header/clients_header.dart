import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../../Services/auth_services.dart';
import '../../language/change_language.dart';
import '../../provider/ThemeNotifier.dart';
import '../panel/clients/abouts_us/abouts_us.dart';
import '../panel/clients/clients_panel.dart';
import '../panel/clients/communication/view_com.dart';
import '../panel/clients/contact_us/contact_us.dart';
import '../panel/clients/history/history.dart';
import '../panel/clients/manage_doc/book_appointment.dart';
import '../panel/clients/manage_doc/payment.dart';
import '../panel/clients/manage_doc/upload_doc.dart';
import '../panel/clients/missing_doc/find_id.dart';
import '../panel/clients/missing_doc/upload_id.dart';
import '../panel/clients/police_grade/grade.dart';
import '../panel/clients/setting/LanguageSelectionPage.dart';
import '../panel/clients/setting/call_center.dart';
import '../panel/clients/setting/logout.dart';
import '../panel/clients/setting/profile.dart';
import '../panel/clients/setting/support.dart';
import '../panel/clients/track/track.dart';

class ClientHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const ClientHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double appBarHeight = MediaQuery.of(context).size.height * 0.1;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: theme.iconTheme.color),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        _appBarIconButton(Icons.search, context, () {
          // Handle search press
        }),
        _appBarIconButton(Icons.settings, context, () => _showSettingsDialog(context)),
        _appBarIconButton(Icons.wb_sunny_outlined, context, () => _showThemeSettingsDialog(context)),
      ],
      toolbarHeight: appBarHeight,
    );
  }

  IconButton _appBarIconButton(IconData icon, BuildContext context, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(icon, color: theme.iconTheme.color),
      onPressed: onPressed,
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _settingsDialog(
          title: 'Settings',
          items: [
            _settingsListTile(context, Icons.person, 'Profile', const ProfilePage()),
            _settingsListTile(context, Icons.language, 'Language', ChangeLanguagePage()),
            _settingsListTile(context, Icons.support_agent, 'Support', const SupportPage()),
            _settingsListTile(context, Icons.logout, 'Log Out', const LogoutPage()),
          ],
        );
      },
    );
  }

  AlertDialog _settingsDialog({required String title, required List<Widget> items}) {
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
          onPressed: () => Navigator.of(context as BuildContext).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  ListTile _settingsListTile(BuildContext context, IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (isLogout) {
          Provider.of<Authservices>(context, listen: false).logout();
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
        return _settingsDialog(
          title: 'Theme Settings',
          items: [
            _themeListTile(context, Icons.brightness_2, 'Dark', (themeNotifier) => themeNotifier.setDarkTheme()),
            _themeListTile(context, Icons.brightness_7, 'Light', (themeNotifier) => themeNotifier.setLightTheme()),
            _themeListTile(context, Icons.settings_brightness, 'Default', (themeNotifier) => themeNotifier.setDefaultTheme()),
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

class ClientDashboardDrawer extends StatelessWidget {
  const ClientDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservices>(context);
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;

    if (authService.name == null || authService.profilePicture == null || authService.email == null) {
      authService.fetchUserDetails();
    }

    return Drawer(
      child: Column(
        children: [
          _drawerHeader(context, authService),
          Expanded(
            child: ListView(
              children: [
                _createDrawerItem(icon: Icons.dashboard, text: 'Dashboard', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientsPanel()))),
                _createBookingAppointmentItem(context),
                _createDrawerItem(icon: Icons.track_changes, text: 'Track Application', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackPage()))),
                _createMissingCNIItem(context),
                _createDrawerItem(icon: Icons.info_outline, text: 'About Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()))),
                _createDrawerItem(icon: Icons.message, text: 'Communication', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunicationPage()))),
                _createDrawerItem(icon: Icons.contact_mail, text: 'Contact Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()))),
                _createDrawerItem(icon: Icons.call, text: 'Call Center', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CombinedContactPage()))),
                _createDrawerItem(icon: Icons.grade, text: 'Police Grade', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PoliceOfficerGradesPage()))),
                _createDrawerItem(icon: Icons.history, text: 'Why having ID Card?', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader(BuildContext context, Authservices authService) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: authService.profilePicture != null
                ? NetworkImage(authService.profilePicture!)
                : const AssetImage('assets/images/yvan.jpg') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authService.name ?? 'Default User',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                authService.email ?? 'default@example.com',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({required IconData icon, required String text, GestureTapCallback? onTap, bool hasDropdown = false, List<Widget>? dropdownItems}) {
    return hasDropdown && dropdownItems != null
        ? ExpansionTile(
      leading: Icon(icon),
      title: Text(text),
      children: dropdownItems,
    )
        : ListTile(
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

  Widget _createBookingAppointmentItem(BuildContext context) {
    return _createDrawerItem(
      icon: Icons.event_note,
      text: 'Booking Appointment',
      hasDropdown: true,
      dropdownItems: [
        _createDropdownItem(icon: Icons.upload_file, text: 'Upload Document', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadDocPage()))),
        _createDropdownItem(icon: Icons.calendar_today, text: 'Choose a Date', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookAppointmentPage()))),
        _createDropdownItem(icon: Icons.payment, text: 'Make Payment', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MakePaymentPage()))),
      ],
    );
  }

  Widget _createMissingCNIItem(BuildContext context) {
    return _createDrawerItem(
      icon: Icons.person_search,
      text: 'Missing CNI',
      hasDropdown: true,
      dropdownItems: [
        _createDropdownItem(icon: Icons.upload_file, text: 'Upload Found ID', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadIDPage()))),
        _createDropdownItem(icon: Icons.search, text: 'Search for ID', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FindIDPage()))),
      ],
    );
  }

  Widget _createDropdownItem({required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}