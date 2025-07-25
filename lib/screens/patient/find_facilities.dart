import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FindFacilitiesScreen extends StatefulWidget {
  const FindFacilitiesScreen({super.key});

  @override
  _FindFacilitiesScreenState createState() => _FindFacilitiesScreenState();
}

class _FindFacilitiesScreenState extends State<FindFacilitiesScreen> {
  final List<HealthcareFacility> _facilities = [
    HealthcareFacility(
      name: 'City General Hospital',
      address: '123 Main St, Anytown',
      distance: '2.5 miles',
      type: 'Hospital',
      phone: '(555) 123-4567',
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    HealthcareFacility(
      name: 'Community Health Clinic',
      address: '456 Oak Ave, Anytown',
      distance: '1.2 miles',
      type: 'Clinic',
      phone: '(555) 987-6543',
      latitude: 37.7812,
      longitude: -122.4113,
    ),
    HealthcareFacility(
      name: '24-Hour Urgent Care',
      address: '789 Pine Rd, Anytown',
      distance: '3.0 miles',
      type: 'Urgent Care',
      phone: '(555) 456-7890',
      latitude: 37.7689,
      longitude: -122.4265,
    ),
    HealthcareFacility(
      name: 'Westside Pharmacy',
      address: '321 Elm St, Anytown',
      distance: '0.8 miles',
      type: 'Pharmacy',
      phone: '(555) 789-0123',
      latitude: 37.7715,
      longitude: -122.4021,
    ),
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredFacilities = _selectedFilter == 'All'
        ? _facilities
        : _facilities.where((f) => f.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find Healthcare Facilities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              items: ['All', 'Hospital', 'Clinic', 'Urgent Care', 'Pharmacy']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Filter by Type',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                final facility = filteredFacilities[index];
                return HealthcareFacilityCard(
                  facility: facility,
                  onCall: () => _callFacility(facility.phone),
                  onDirections: () => _openMaps(facility.latitude, facility.longitude),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callFacility(String phone) async {
    final Uri url = Uri.parse('tel:${phone.replaceAll(RegExp(r'[^0-9]'), '')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone call')),
      );
    }
  }

  Future<void> _openMaps(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }
}

class HealthcareFacility {
  final String name;
  final String address;
  final String distance;
  final String type;
  final String phone;
  final double latitude;
  final double longitude;

  HealthcareFacility({
    required this.name,
    required this.address,
    required this.distance,
    required this.type,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}

class HealthcareFacilityCard extends StatelessWidget {
  final HealthcareFacility facility;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  const HealthcareFacilityCard({
    super.key,
    required this.facility,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  facility.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(facility.type),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(facility.address),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 16),
                const SizedBox(width: 4),
                Text(facility.distance),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                ),
                TextButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
