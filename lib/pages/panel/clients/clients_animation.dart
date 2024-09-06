import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class ClientsAnimation extends StatefulWidget {
  const ClientsAnimation({Key? key, required bool isLoading, required Set<Marker> markers}) : super(key: key);

  @override
  _ClientsAnimationState createState() => _ClientsAnimationState();
}

class _ClientsAnimationState extends State<ClientsAnimation> {
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPoliceStations();
  }

  Future<void> _fetchPoliceStations() async {
    final latitude = 3.848; // Replace with actual latitude
    final longitude = 11.5021; // Replace with actual longitude
    final url = Uri.parse('http://your-api-url/api/nearby-police-stations/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> policeStations = json.decode(response.body)['police_stations'];
        setState(() {
          _isLoading = false;
          _markers.clear();
          for (var station in policeStations) {
            _markers.add(
              Marker(
                markerId: MarkerId(station['name']),
                position: LatLng(station['latitude'], station['longitude']),
                infoWindow: InfoWindow(
                  title: station['name'],
                  snippet: station['address'],
                ),
              ),
            );
          }
        });
      } else {
        throw Exception('Failed to load police stations');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load police stations: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        // Slidable Image Carousel for Publicity
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
          items: [
            'assets/images/cni.jpeg',
            'assets/images/cn1.jpeg',
            'assets/images/cni2.jpeg',
          ].map((item) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(item),
                fit: BoxFit.cover,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // Statistics Boxes
        isMobile
            ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStatisticsCard(
                title: 'Cameroon Population',
                subtitle: 'Estimated Population',
                content: 'Approx. 27 million',
                color: Colors.blueAccent,
              ),
              _buildStatisticsCard(
                title: 'National ID Card Holders',
                subtitle: 'Citizens with ID Cards',
                content: 'Around 45%',
                color: Colors.green,
              ),
              _buildStatisticsCard(
                title: 'Administrative Divisions',
                subtitle: 'Regions, Communes, Villages',
                content: 'Regions: 10\nCommunes: Thousands\nVillages: Numerous',
                color: Colors.orange,
              ),
              _buildStatisticsCard(
                title: 'Official Languages',
                subtitle: 'Languages Spoken',
                content: 'English and French',
                color: Colors.teal,
              ),
            ],
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatisticsCard(
              title: 'Cameroon Population',
              subtitle: 'Estimated Population',
              content: 'Approx. 27 million',
              color: Colors.blueAccent,
            ),
            _buildStatisticsCard(
              title: 'National ID Card Holders',
              subtitle: 'Citizens with ID Cards',
              content: 'Around 45%',
              color: Colors.green,
            ),
            _buildStatisticsCard(
              title: 'Administrative Divisions',
              subtitle: 'Regions, Communes, Villages',
              content: 'Regions: 10\nCommunes: Thousands\nVillages: Numerous',
              color: Colors.orange,
            ),
            _buildStatisticsCard(
              title: 'Official Languages',
              subtitle: 'Languages Spoken',
              content: 'English and French',
              color: Colors.teal,
            ),
            _buildStatisticsCard(
              title: 'Economy',
              subtitle: 'Economic Overview',
              content: 'Agriculture, Oil, and Mining',
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Nearby Police Stations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isMobile ? 300 : 400,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(3.848, 11.5021),
              zoom: 6,
            ),
            markers: _markers,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard({
    required String title,
    required String subtitle,
    required String content,
    required Color color,
  }) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
