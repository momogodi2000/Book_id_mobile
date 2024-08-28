import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final List<DashboardWidgetData> _dashboardWidgets = [
    DashboardWidgetData(
      title: 'Total Users',
      value: '1000',
      icon: Icons.person,
      color: Colors.green,
    ),
    DashboardWidgetData(
      title: 'Active Orders',
      value: '50',
      icon: Icons.shopping_cart,
      color: Colors.yellow,
    ),
    DashboardWidgetData(
      title: 'Recent Revenue',
      value: '\$10,000',
      icon: Icons.attach_money,
      color: Colors.blue,
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: screenWidth < 600 ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = (constraints.maxWidth > 600) ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                ),
                itemCount: _dashboardWidgets.length,
                itemBuilder: (context, index) {
                  return DashboardWidget(
                    title: _dashboardWidgets[index].title,
                    value: _dashboardWidgets[index].value,
                    icon: _dashboardWidgets[index].icon,
                    color: _dashboardWidgets[index].color,
                  );
                },
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
  final String value;
  final IconData icon;
  final Color color;

  DashboardWidgetData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class DashboardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardWidget({
    required this.title,
    required this.value,
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
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
