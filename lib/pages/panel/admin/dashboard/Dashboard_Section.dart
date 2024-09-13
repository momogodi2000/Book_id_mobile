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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: screenWidth < 600 ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600 ? 2 : 3,
              crossAxisSpacing: screenWidth * 0.03,
              mainAxisSpacing: screenWidth * 0.03,
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
    );
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36,
            color: color,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Count: $count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}