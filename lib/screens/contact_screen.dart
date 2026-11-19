import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Widget contactItem(IconData icon, String titre, String valeur) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 30),
        title: Text(titre),
        subtitle: Text(valeur),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes coordonnées'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.contact_mail, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),

            contactItem(Icons.email, 'Adresse e-mail', 'micheek845@gmail.com'),

            contactItem(Icons.phone, 'Téléphone 1', '+243 992 063 754'),

            contactItem(Icons.phone_android, 'Téléphone 2', '+243 840 549 526'),

            contactItem(
              Icons.location_on,
              'Adresse',
              'Commune de Goma, quartier Himbi',
            ),
          ],
        ),
      ),
    );
  }
}
