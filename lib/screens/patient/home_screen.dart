
// lib/screens/patient/home_screen.dart
import 'package:flutter/material.dart';
import '../doctor/add_vital_signs_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello,',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Welcome to MediConnect!',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TeleHealth ChatBot',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Ask health questions to our AI chatbot'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildActionButton(
                'Medication Reminder',
                Icons.alarm,
                () => Navigator.pushNamed(context, '/medication_reminder'),
              ),
              _buildActionButton(
                'Health Library',
                Icons.library_books,
                () => Navigator.pushNamed(context, '/health_library'),
              ),
              _buildActionButton(
                'Emergency',
                Icons.emergency,
                () => Navigator.pushNamed(context, '/emergency'),
              ),
              _buildActionButton(
                'Find Facilities',
                Icons.local_hospital,
                () => Navigator.pushNamed(context, '/find_facilities'),
              ),
              _buildActionButton(
                'Add Vital Signs',
                Icons.monitor_heart,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddVitalSignsScreen(patientId: ''),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Health Tips',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eat a Balanced Diet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Maintain a diet rich in fruits and vegetables.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
