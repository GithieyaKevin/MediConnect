
// lib/screens/patient/health_screen.dart
import 'package:flutter/material.dart';
import './patient/health_library.dart';
import './patient/health_tips.dart';
import './patient/medication_reminder.dart';
import './patient/emergency.dart';
import './patient/find_facilities.dart';
import './patient/health_records.dart';
import '../widgets/health_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Resources',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                HealthCard(
                  title: 'Medication Reminder',
                  icon: Icons.medication,
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/medication_reminder'),
                ),
                HealthCard(
                  title: 'Health Library',
                  icon: Icons.library_books,
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/health_library'),
                ),
                HealthCard(
                  title: 'Health Tips',
                  icon: Icons.health_and_safety,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/health_tips'),
                ),
                HealthCard(
                  title: 'Emergency Contacts',
                  icon: Icons.emergency,
                  color: Colors.red,
                  onTap: () => Navigator.pushNamed(context, '/emergency'),
                ),
                HealthCard(
                  title: 'Find Facilities',
                  icon: Icons.local_hospital,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/find_facilities'),
                ),
                HealthCard(
                  title: 'Health Records',
                  icon: Icons.assignment,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/health_records'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No recent activity available.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
