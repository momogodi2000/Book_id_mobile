import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';
import '../../clients/missing_doc/upload_id.dart';
import 'DetailMissingPage.dart';

class FindIDPage extends StatefulWidget {
  const FindIDPage({Key? key}) : super(key: key);

  @override
  _FindIDPageState createState() => _FindIDPageState();
}

class _FindIDPageState extends State<FindIDPage> {
  List<dynamic> foundIDs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMissingIDCards();
  }

  Future<void> fetchMissingIDCards() async {
    final authService = Provider.of<Authservices>(context, listen: false);
    try {
      final ids = await authService.fetchMissingIDCards();
      setState(() {
        foundIDs = ids;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching missing IDs: $error');
    }
  }

  Future<void> _deleteIDCard(String id) async {
    final authService = Provider.of<Authservices>(context, listen: false);
    try {
      await authService.deleteIDCard(id);
      fetchMissingIDCards(); // Refresh the list after deletion
    } catch (error) {
      print('Error deleting ID card: $error');
    }
  }

  void _showDetailDialog(dynamic idCard) {
    showDialog(
      context: context,
      builder: (context) {
        return DetailMissingPage(idCard: idCard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Found National ID Cards'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildDescription(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildIDCardList(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadIDPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        tooltip: 'Add Missing ID Card',
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Missing National IDs Found',
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

  Widget _buildDescription(double screenWidth) {
    return Text(
      'Below is a list of national ID cards that have been found. '
          'If your ID is listed, please contact the finder.',
      style: TextStyle(
        fontSize: screenWidth * 0.045,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildIDCardList(double screenHeight, double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foundIDs.length,
      itemBuilder: (context, index) {
        final idCard = foundIDs[index];
        return GestureDetector(
          onTap: () => _showDetailDialog(idCard),
          child: Card(
            margin: EdgeInsets.only(bottom: screenHeight * 0.03),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Found by: ${idCard['name']}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Date Found: ${idCard['date_found']}',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Contact: ${idCard['phone']}',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          'Email: ${idCard['email']}',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Image.network(
                          'http://192.168.1.173:8000${idCard['id_card_image']}', // Adjust the URL as needed
                          height: screenHeight * 0.25,
                          width: screenWidth,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteIDCard(idCard['id']); // Assuming 'id' is the unique identifier
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}