import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../Services/auth_services.dart';
import '../../header/clients_header.dart';
import 'clients_animation.dart'; // Import the new widget

class ClientsPanel extends StatefulWidget {
  const ClientsPanel({super.key});

  @override
  _ClientsPanelState createState() => _ClientsPanelState();
}

class _ClientsPanelState extends State<ClientsPanel> {
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPoliceStations();
  }

  Future<void> _fetchPoliceStations() async {
    final authService = Provider.of<Authservices>(context, listen: false);
    try {
      final stations = await authService.fetchPoliceStations(3.848, 11.5021);
      setState(() {
        _markers = stations.map<Marker>((station) {
          return Marker(
            markerId: MarkerId(station['name']),
            position: LatLng(station['latitude'], station['longitude']),
            infoWindow: InfoWindow(title: station['name']),
          );
        }).toSet();
        _isLoading = false;
      });
    } catch (error) {
      // Handle error (e.g., show a message)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClientHeaderPage(),
      drawer: const ClientDashboardDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClientsAnimation(
            markers: _markers,
            isLoading: _isLoading,
          ),
        ),
      ),
    );
  }
}
