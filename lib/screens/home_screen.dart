import 'package:flutter/material.dart';
import 'family_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Mon Curriculum Vitae',
    'Ma famille',
    'Mes coordonnées',
  ];

  Widget section(String titre, List<String> elements) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titre,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            ...elements.map(
              (element) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• $element', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCV() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profil.png'),
          ),
          const SizedBox(height: 12),
          const Text(
            'MICHEE KADIMA WAZEKA',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Étudiant en informatique',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          section('Formation', [
            'L3 - Institut Supérieur d’Informatique et de Gestion (ISIG-GOMA)',
            'Domaine : Informatique',
          ]),

          section('Expériences professionnelles', [
            'Secrétariat Mairie de Goma',
            'DPS : travaux d’encodage',
          ]),

          section('Compétences informatiques', [
            'Microsoft Word',
            'Microsoft Excel',
            'Microsoft PowerPoint',
            'Développement d’applications web',
          ]),

          section('Langues', [
            'Français',
            'Anglais',
            'Swahili',
            'Lingala',
            'Tshiluba',
          ]),

          section('Centres d’intérêt', [
            'Entrepreneuriat',
            'Nouvelles technologies',
            'Lecture',
            'Sport',
            'Voyages',
            'Musique',
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [buildCV(), FamilyScreen(), ContactScreen()];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: IndexedStack(index: selectedIndex, children: pages),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone),
            label: 'Contacts',
          ),
        ],
      ),
    );
  }
}
