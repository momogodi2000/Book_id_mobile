import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../models/police_models/appointment.dart';
import '../../../header/police_header.dart';
import 'Appointment_detail.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PoliceHeaderPage(), // Using the imported PoliceHeaderPage
      drawer: const PoliceDashboardDrawer(), // Using the imported PoliceDashboardDrawer
      body: FutureBuilder<List<Appointment>>(
        future: Authservices().fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
                duration: Duration(milliseconds: 1200), // Added animation duration
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No appointments found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final appointment = snapshot.data![index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                    'Appointment ID: ${appointment.id}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${appointment.date} | Time: ${appointment.time}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailPage(appointment: appointment),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}