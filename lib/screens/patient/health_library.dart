import 'package:flutter/material.dart';

class HealthLibraryScreen extends StatefulWidget {
  const HealthLibraryScreen({super.key});

  @override
  _HealthLibraryScreenState createState() => _HealthLibraryScreenState();
}

class _HealthLibraryScreenState extends State<HealthLibraryScreen> {
  final List<HealthCategory> _categories = [
    HealthCategory(
      title: 'Common Conditions',
      topics: [
        'Cold and Flu',
        'Allergies',
        'Headaches',
        'Diabetes',
        'High Blood Pressure',
      ],
      icon: Icons.medical_services,
    ),
    HealthCategory(
      title: 'Medications',
      topics: [
        'Antibiotics',
        'Pain Relievers',
        'Antidepressants',
        'Blood Pressure Meds',
        'Diabetes Medications',
      ],
      icon: Icons.medication,
    ),
    HealthCategory(
      title: 'Procedures',
      topics: [
        'Blood Tests',
        'X-Rays',
        'Vaccinations',
        'Physical Therapy',
        'Minor Surgeries',
      ],
      icon: Icons.medical_information,
    ),
    HealthCategory(
      title: 'Healthy Living',
      topics: [
        'Nutrition',
        'Exercise',
        'Mental Health',
        'Sleep Hygiene',
        'Preventive Care',
      ],
      icon: Icons.health_and_safety,
    ),
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories.map((category) {
      final filteredTopics = category.topics
          .where((topic) =>
              topic.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
      return HealthCategory(
        title: category.title,
        topics: filteredTopics,
        icon: category.icon,
      );
    }).where((category) => category.topics.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Health Library')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Health Topics',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return HealthCategoryCard(category: category);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HealthCategory {
  final String title;
  final List<String> topics;
  final IconData icon;

  HealthCategory({
    required this.title,
    required this.topics,
    required this.icon,
  });
}

class HealthCategoryCard extends StatelessWidget {
  final HealthCategory category;

  const HealthCategoryCard({super.key, required this.category});

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
              children: [
                Icon(category.icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  category.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...category.topics.map((topic) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(topic),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to topic detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthTopicScreen(topic: topic),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class HealthTopicScreen extends StatelessWidget {
  final String topic;

  const HealthTopicScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    // Mock content - in a real app, this would come from a database
    final content = {
      'Cold and Flu': '''
### Symptoms:
- Fever or feeling feverish/chills
- Cough
- Sore throat
- Runny or stuffy nose
- Muscle or body aches
- Headaches
- Fatigue

### Treatment:
- Get plenty of rest
- Drink fluids
- Use over-the-counter medications to relieve symptoms
- Antiviral drugs may be prescribed by your doctor
''',
      'Allergies': '''
### Symptoms:
- Sneezing
- Itchy nose, eyes or roof of the mouth
- Runny, stuffy nose
- Watery, red or swollen eyes

### Treatment:
- Avoid allergens
- Antihistamines
- Nasal sprays
- Decongestants
- Immunotherapy for severe cases
''',
    }[topic] ?? 'Information about $topic coming soon.';

    return Scaffold(
      appBar: AppBar(title: Text(topic)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
