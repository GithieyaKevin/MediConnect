import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _callEmergency(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'In case of emergency, contact:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            EmergencyContactCard(
              title: 'Ambulance',
              number: '911',
              icon: Icons.medical_services,
              color: Colors.red,
              onTap: () => _callEmergency('911'),
            ),
            EmergencyContactCard(
              title: 'Poison Control',
              number: '1-800-222-1222',
              icon: Icons.warning,
              color: Colors.orange,
              onTap: () => _callEmergency('18002221222'),
            ),
            EmergencyContactCard(
              title: 'Suicide Prevention',
              number: '988',
              icon: Icons.health_and_safety,
              color: Colors.blue,
              onTap: () => _callEmergency('988'),
            ),
            EmergencyContactCard(
              title: 'My Doctor',
              number: '(555) 123-4567',
              icon: Icons.person,
              color: Colors.green,
              onTap: () => _callEmergency('5551234567'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Emergency Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Stay calm and assess the situation'),
                    Text('2. Call emergency services if needed'),
                    Text('3. Provide clear information about the emergency'),
                    Text('4. Follow instructions from emergency personnel'),
                    Text('5. Administer first aid if trained to do so'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyContactCard extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const EmergencyContactCard({
    super.key,
    required this.title,
    required this.number,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(number),
                  ],
                ),
              ),
              Icon(Icons.call, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
