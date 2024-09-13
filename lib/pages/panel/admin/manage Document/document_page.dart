import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';


import '../../../header/admin_header.dart'; // Import your custom drawer

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List documents = [];
  List missingIDCards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final authServices = Provider.of<Authservices>(context, listen: false);
      final fetchedDocuments = await authServices.fetchDocuments();
      final fetchedMissingIDCards = await authServices.fetchMissingIDCards();

      // Debugging output
      print('Fetched Documents: $fetchedDocuments');
      print('Fetched Missing ID Cards: $fetchedMissingIDCards');

      setState(() {
        documents = fetchedDocuments;
        missingIDCards = fetchedMissingIDCards;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AdminHeaderPage(), // Use your custom app bar
      drawer: AdminDashboardDrawer(), // Use your custom drawer
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uploaded Documents',
                  style: Theme.of(context).textTheme.headlineMedium, // Updated
                ),
                const SizedBox(height: 16.0),
                _buildDocumentsList(),
                const SizedBox(height: 32.0),
                Text(
                  'Missing ID Cards',
                  style: Theme.of(context).textTheme.headlineMedium, // Updated
                ),
                const SizedBox(height: 16.0),
                _buildMissingIDCardsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return _buildDocumentCard(document);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${document['user']['username']}',
              style: Theme.of(context).textTheme.bodyMedium, // Updated
            ),
            const SizedBox(height: 8.0),
            _buildDocumentFiles(document),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentFiles(Map<String, dynamic> document) {
    List<String> fileFields = [
      'birth_certificate',
      'proof_of_nationality',
      'passport_photos',
      'residence_permit',
      'marriage_certificate',
      'death_certificate',
      'sworn_statement'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fileFields.map((field) {
        final fileUrl = document[field];
        if (fileUrl != null && fileUrl.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('$field: $fileUrl'),
          );
        }
        return Container();
      }).toList(),
    );
  }

  Widget _buildMissingIDCardsList() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: missingIDCards.length,
            itemBuilder: (context, index) {
              final missingCard = missingIDCards[index];
              return _buildMissingIDCard(missingCard);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMissingIDCard(Map<String, dynamic> missingCard) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${missingCard['name']}',
              style: Theme.of(context).textTheme.bodyMedium, // Updated
            ),
            const SizedBox(height: 8.0),
            Text('Email: ${missingCard['email']}'),
            Text('Phone: ${missingCard['phone']}'),
            if (missingCard['id_card_image'] != null)
              Image.network(
                '${missingCard['id_card_image']}', // Assuming valid URL
                height: 100,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}