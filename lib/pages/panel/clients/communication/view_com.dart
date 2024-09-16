import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../../header/clients_header.dart';
import 'downlaod.dart';

class CommunicationPage extends StatefulWidget {
  const CommunicationPage({super.key});

  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  List<dynamic> communications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCommunications();
  }

  Future<void> fetchCommunications() async {
    final authServices = Provider.of<Authservices>(context, listen: false);
    try {
      final data = await authServices.fetchCommunications();
      setState(() {
        communications = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ClientHeaderPage(),
      drawer: const ClientDashboardDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedHeader(screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildCommunicationList(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Recent Communications',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommunicationList(double screenWidth, double screenHeight) {
    return Column(
      children: communications.map((communication) {
        return _buildCommunicationCard(communication, screenWidth, screenHeight);
      }).toList(),
    );
  }

  Widget _buildCommunicationCard(Map<String, dynamic> communication, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "http://192.168.100.5:8000/" + communication['location'], // Updated network image
                      width: screenWidth,
                      height: screenHeight * 0.25,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Title: ${communication['title']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DownloadPage(
                              communication: communication,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Download PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
