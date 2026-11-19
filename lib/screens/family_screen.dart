import 'package:flutter/material.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  final List<Map<String, String>> family = const [
    {
      'name': 'LUNANGA ZEKHA ADOLPH',
      'relation': 'Père',
      'job': 'Infirmier superviseur',
    },
    {
      'name': 'MBOMBO KADIMA Marie-Jeanne',
      'relation': 'Mère',
      'job': 'Commerçante',
    },
    {
      'name': 'KUBOTA WAZEKA Jedidia',
      'relation': 'Frère aîné',
      'job': 'Architecte',
    },
    {
      'name': 'BULUMBA WAZEKA SIMEON',
      'relation': 'Petit frère',
      'job': 'Nutritionniste',
    },
    {
      'name': 'ZAWADI BYAMUNGU Marie',
      'relation': 'Petite sœur',
      'job': 'Professeur',
    },
    {
      'name': 'MUSAGHI ZEKHA DAVID',
      'relation': 'Petit frère',
      'job': 'Électronicien',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma famille'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: family.length,
        itemBuilder: (context, index) {
          final member = family[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                radius: 27,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                member['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${member['relation']} • ${member['job']}'),
            ),
          );
        },
      ),
    );
  }
}
