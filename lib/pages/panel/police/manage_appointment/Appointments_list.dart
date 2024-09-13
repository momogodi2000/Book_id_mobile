import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../models/police_models/appointment.dart';
import 'Appointment_detail.dart';


class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointments')),
      body: FutureBuilder<List<Appointment>>(
        future: Authservices().fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(color: Colors.blue, size: 50.0),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final appointment = snapshot.data![index];
              return ListTile(
                title: Text('Appointment ID: ${appointment.id}'),
                subtitle: Text('Date: ${appointment.date} | Time: ${appointment.time}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetailPage(appointment: appointment),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
