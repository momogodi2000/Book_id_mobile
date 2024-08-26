import 'package:flutter/material.dart';
import 'AddIdCardPage.dart';
import 'EditIdCardPage.dart';

class ViewIdCardsPage extends StatefulWidget {
  const ViewIdCardsPage({super.key});

  @override
  _ViewIdCardsPageState createState() => _ViewIdCardsPageState();
}

class _ViewIdCardsPageState extends State<ViewIdCardsPage> {
  final List<IdCard> idCards = [
    IdCard(name: 'John Doe', email: 'john@example.com', phone: '123456789', idCardImage: 'assets/images/momo.jpg'),
    IdCard(name: 'Jane Smith', email: 'jane@example.com', phone: '987654321', idCardImage: 'assets/images/momo.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Missing ID Cards'),
      ),
      body: ListView.builder(
        itemCount: idCards.length,
        itemBuilder: (context, index) {
          return IdCardItem(
            idCard: idCards[index],
            onDelete: () {
              setState(() {
                idCards.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const Dialog(
              child: AddIdCardPage(),
            ),
          );
          if (result == true) {
            // Reload the list after adding a new ID card if necessary
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class IdCard {
  final String name;
  final String email;
  final String phone;
  final String idCardImage;

  IdCard({required this.name, required this.email, required this.phone, required this.idCardImage});
}

class IdCardItem extends StatelessWidget {
  final IdCard idCard;
  final VoidCallback onDelete;

  const IdCardItem({super.key, required this.idCard, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(idCard.idCardImage, width: 50, height: 50),
        title: Text(idCard.name),
        subtitle: Text('Email: ${idCard.email}\nPhone: ${idCard.phone}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditIdCardPage(idCard: idCard)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
