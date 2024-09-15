import 'dart:math' as math; // Import Dart's math library
import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator import

class NearbyPoliceStationsPage extends StatefulWidget {
  @override
  _NearbyPoliceStationsPageState createState() =>
      _NearbyPoliceStationsPageState();
}

class _NearbyPoliceStationsPageState extends State<NearbyPoliceStationsPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Marker> _markers = [];
  LatLng? _nearestPoliceStation;
  bool _isLoading = true;

  // Create an instance of AuthService
  final Authservices _authService = Authservices();

  // Fetch user's location using Geolocator
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location of the user
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    _fetchNearbyPoliceStations();
  }

  // Fetch nearby police stations using AuthService
  Future<void> _fetchNearbyPoliceStations() async {
    if (_currentPosition == null) return;

    try {
      List<Map<String, dynamic>> policeStations = await _authService
          .fetchNearbyPoliceStations(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      LatLng? nearestStation; // Initialize nearestStation as nullable
      double shortestDistance = double.infinity;

      // Add markers for all police stations
      policeStations.forEach((station) {
        final stationLocation = LatLng(station['latitude'], station['longitude']);
        final marker = Marker(
          markerId: MarkerId(station['name']),
          position: stationLocation,
          infoWindow: InfoWindow(title: station['name'], snippet: station['address']),
        );

        // Calculate the nearest police station
        double distance = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          station['latitude'],
          station['longitude'],
        );

        if (distance < shortestDistance) {
          shortestDistance = distance;
          nearestStation = stationLocation; // Assign nearestStation
        }

        setState(() {
          _markers.add(marker);
        });
      });

      // Set nearest station
      setState(() {
        _nearestPoliceStation = nearestStation;
        _isLoading = false;
      });

      // Zoom in on the map to show user's location
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          12.0,
        ),
      );
    } catch (e) {
      // Handle error
      print("Error fetching police stations: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to calculate distance between two locations
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final c = math.cos;
    final a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a)); // Use Dart's math.asin and math.sqrt
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Police Stations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0), // Placeholder until location is fetched
              zoom: 12.0,
            ),
            markers: Set.from(_markers),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the nearest police station
                if (_nearestPoliceStation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_nearestPoliceStation!, 14.0),
                  );
                }
              },
              child: Text("Go to Nearest Station"),
            ),
          ),
        ],
      ),
    );
  }
}
