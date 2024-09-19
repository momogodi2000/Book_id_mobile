import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final List<DashboardWidgetData> _dashboardWidgets = [
    DashboardWidgetData(
      title: 'User',
      description: 'Manage user information and roles.',
      count: '5',
      icon: Icons.person,
      color: Colors.green,
    ),
    DashboardWidgetData(
      title: 'Statistics',
      description: 'View system statistics and metrics.',
      count: '3',
      icon: Icons.bar_chart,
      color: Colors.blue,
    ),
    DashboardWidgetData(
      title: 'Analyze',
      description: 'Analyze data and trends.',
      count: '3',
      icon: Icons.trending_up,
      color: Colors.orange,
    ),
    DashboardWidgetData(
      title: 'Payment',
      description: 'Manage payments and transactions.',
      count: '6',
      icon: Icons.attach_money,
      color: Colors.yellow,
    ),
    DashboardWidgetData(
      title: 'Missing ID Card',
      description: 'Manage reports of missing ID cards.',
      count: '0',
      icon: Icons.warning,
      color: Colors.red,
    ),
    DashboardWidgetData(
      title: 'Appointment',
      description: 'Manage user appointments.',
      count: '4',
      icon: Icons.calendar_today,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(screenWidth),
                crossAxisSpacing: screenWidth * 0.03,
                mainAxisSpacing: screenWidth * 0.03,
                childAspectRatio: _getAspectRatio(screenWidth),
              ),
              itemCount: _dashboardWidgets.length,
              itemBuilder: (context, index) {
                return DashboardWidget(
                  title: _dashboardWidgets[index].title,
                  description: _dashboardWidgets[index].description,
                  count: _dashboardWidgets[index].count,
                  icon: _dashboardWidgets[index].icon,
                  color: _dashboardWidgets[index].color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) {
      return 4; // Large screens (desktops)
    } else if (screenWidth > 800) {
      return 3; // Tablets or medium-sized screens
    } else {
      return 2; // Mobile
    }
  }

  double _getAspectRatio(double screenWidth) {
    if (screenWidth > 1200) {
      return 1.0; // Square-ish cards for large screens
    } else if (screenWidth > 800) {
      return 0.9; // Slightly wider cards for medium screens
    } else {
      return 0.75; // Narrower cards for mobile devices
    }
  }
}

class DashboardWidgetData {
  final String title;
  final String description;
  final String count;
  final IconData icon;
  final Color color;

  DashboardWidgetData({
    required this.title,
    required this.description,
    required this.count,
    required this.icon,
    required this.color,
  });
}

class DashboardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String count;
  final IconData icon;
  final Color color;

  const DashboardWidget({
    required this.title,
    required this.description,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: screenWidth * 0.05,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Count: $count',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}