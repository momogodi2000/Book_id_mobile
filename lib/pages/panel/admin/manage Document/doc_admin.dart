import 'package:flutter/material.dart';
import 'package:cni/Services/auth_services.dart';
import '../../../../models/admin_models/document_models.dart';
import '../../../../models/police_models/missing_id_card.dart';
import '../../../header/admin_header.dart';

class StatisticDoc extends StatefulWidget {
  @override
  _StatisticDocState createState() => _StatisticDocState();
}

class _StatisticDocState extends State<StatisticDoc> {
  late Future<List<Document>> documents;
  late Future<List<MissingIDCard>> missingIDCards;
  final Authservices authService = Authservices();

  @override
  void initState() {
    super.initState();
    documents = authService.fetchDocumentsFromAPI();
    missingIDCards = authService.fetchMissingIDCardsFromAPi();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AdminHeaderPage(), // Custom AppBar
      drawer: AdminDashboardDrawer(), // Custom Drawer
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Documents Table
              FutureBuilder<List<Document>>(
                future: documents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Documents Available'));
                  }

                  final docs = snapshot.data!;
                  return buildDataTable(docs, 'Documents', isMobile);
                },
              ),
              SizedBox(height: 20),
              // Missing ID Cards Table
              FutureBuilder<List<MissingIDCard>>(
                future: missingIDCards,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Missing ID Cards Available'));
                  }

                  final missingCards = snapshot.data!;
                  return buildDataTable(missingCards, 'Missing ID Cards', isMobile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataTable<T>(List<T> items, String title, bool isMobile) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // For mobile scrolling
              child: DataTable(
                columns: getColumns<T>(),
                rows: items.map((item) => getDataRow(item)).toList(),
                columnSpacing: isMobile ? 20 : 50, // Adjust column spacing for mobile
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getColumns<T>() {
    if (T == Document) {
      return [
        DataColumn(label: Text('User')),
        DataColumn(label: Text('Birth Certificate')),
        DataColumn(label: Text('Nationality Proof')),
        DataColumn(label: Text('Passport Photos')),
        DataColumn(label: Text('Residence Permit')),
        DataColumn(label: Text('Marriage Certificate')),
        DataColumn(label: Text('Death Certificate')),
        DataColumn(label: Text('Sworn Statement')),
      ];
    } else if (T == MissingIDCard) {
      return [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Phone')),
        DataColumn(label: Text('Date Found')),
        DataColumn(label: Text('ID Card Image')),
      ];
    }
    return [];
  }

  DataRow getDataRow<T>(T item) {
    if (item is Document) {
      return DataRow(cells: [
        DataCell(Text(item.birthCertificate)),
        DataCell(Text(item.proofOfNationality)),
        DataCell(Text(item.passportPhotos)),
        DataCell(Text(item.residencePermit ?? 'N/A')),
        DataCell(Text(item.marriageCertificate ?? 'N/A')),
        DataCell(Text(item.deathCertificate ?? 'N/A')),
        DataCell(Text(item.swornStatement ?? 'N/A')),
      ]);
    } else if (item is MissingIDCard) {
      return DataRow(cells: [
        DataCell(Text(item.name)),
        DataCell(Text(item.email)),
        DataCell(Text(item.phone)),
        DataCell(Text(item.dateFound != null ? item.dateFound.toString() : 'N/A')),
        DataCell(
          GestureDetector(
            onTap: () {
              // Show the dialog with the image when the "View Image" is tapped
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(item.idCardImage), // Assuming `item.idCardImage` is the URL of the image
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(
              'View Image',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ]);
    }
    return DataRow(cells: []);
  }
}
