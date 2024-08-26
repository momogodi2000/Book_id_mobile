import 'package:flutter/material.dart';
import 'package:cni/pages/panel/clients/missing_doc/find_id.dart';
import '../panel/clients/abouts_us/abouts_us.dart';
import '../panel/clients/communication/view_com.dart';
import '../panel/clients/contact_us/contact_us.dart';
import '../panel/clients/manage_doc/book_appointment.dart';
import '../panel/clients/manage_doc/payment.dart';
import '../panel/clients/manage_doc/upload_doc.dart';
import '../panel/clients/missing_doc/upload_id.dart';
import '../panel/clients/setting/call_center.dart';
import '../panel/clients/track/track.dart';

class ClientHeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const ClientHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.1; // Responsive height

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
                            // Navigate to ProfilePage
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            // Handle Settings
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.support_agent),
                          title: const Text('Support'),
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            // Navigate to SupportPage
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Log Out'),
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
      ],
      toolbarHeight: appBarHeight, // Responsive AppBar height
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Drawer for Client Dashboard
class ClientDashboardDrawer extends StatelessWidget {
  const ClientDashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    double avatarRadius = drawerWidth * 0.15;

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Client Dashboard',
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
                  icon: Icons.event_note,
                  text: 'Booking Appointment',
                  onTap: () {
                    // Handle booking appointment
                  },
                  hasDropdown: true,
                  dropdownItems: [
                    _createDropdownItem(
                      icon: Icons.upload_file,
                      text: 'Upload Document',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadDocPage()),
                        );
                      },
                    ),
                    _createDropdownItem(
                      icon: Icons.calendar_today,
                      text: 'Choose a Date',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookAppointmentPage()),
                        );
                      },
                    ),
                    _createDropdownItem(
                      icon: Icons.payment,
                      text: 'Make Payment',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MakePaymentPage()),
                        );
                      },
                    ),
                  ],
                ),
                _createDrawerItem(
                  icon: Icons.track_changes,
                  text: 'Track Application',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrackPage()),
                    );
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
                  icon: Icons.person_search,
                  text: 'Missing CNI',
                  dropdownItems: [
                    _createDropdownItem(
                      icon: Icons.upload_file,
                      text: 'Upload Found ID',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadIDPage()),
                        );
                      },
                    ),
                    _createDropdownItem(
                      icon: Icons.search,
                      text: 'Search for ID',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FindIDPage()),
                        );
                      },
                    ),
                  ],
                ),
                _createDrawerItem(
                  icon: Icons.info_outline,
                  text: 'About Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()),
                    );
                  },
                ),
                _createDrawerItem(
                  icon: Icons.message,
                  text: 'Communication',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CommunicationPage()),
                    );
                  },
                ),
                _createDrawerItem(
                  icon: Icons.contact_mail,
                  text: 'Contact Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactUsPage()),
                    );
                  },
                ),
                _createDrawerItem(
                  icon: Icons.call,
                  text: 'Call Center',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CallCenterPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const NetworkImage(
                    'assets/images/auth.jpeg', // Replace with the client's profile image URL
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Client Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
    bool hasDropdown = false,
    List<Widget>? dropdownItems,
  }) {
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

  Widget _createDropdownItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
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
}
