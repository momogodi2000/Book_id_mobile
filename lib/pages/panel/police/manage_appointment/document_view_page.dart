import 'package:flutter/material.dart';

class DocumentViewPage extends StatelessWidget {
  final List<String> documentUrls;

  DocumentViewPage({required this.documentUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Photos'),
      ),
      body: documentUrls.isEmpty
          ? Center(
        child: Text(
          'No documents available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: documentUrls.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Document ${index + 1}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewPage(imageUrl: documentUrls[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ImageViewPage extends StatelessWidget {
  final String imageUrl;

  ImageViewPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Image'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}