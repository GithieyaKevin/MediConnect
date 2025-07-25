import 'package:flutter/material.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  _HealthTipsScreenState createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final List<HealthTip> _healthTips = [
    HealthTip(
      title: 'Eat a Balanced Diet',
      description:
          'Maintain a diet rich in fruits, vegetables, whole grains, lean proteins, and healthy fats. Limit processed foods, sugar, and excessive salt.',
      category: 'Nutrition',
    ),
    HealthTip(
      title: 'Stay Hydrated',
      description:
          'Drink at least 8 glasses of water daily. Proper hydration helps with digestion, circulation, and temperature regulation.',
      category: 'Nutrition',
    ),
    HealthTip(
      title: 'Exercise Regularly',
      description:
          'Aim for at least 150 minutes of moderate aerobic activity or 75 minutes of vigorous activity each week, plus muscle-strengthening exercises.',
      category: 'Fitness',
    ),
    HealthTip(
      title: 'Get Enough Sleep',
      description:
          'Adults should aim for 7-9 hours of quality sleep per night. Good sleep improves brain function, mood, and overall health.',
      category: 'Wellness',
    ),
    HealthTip(
      title: 'Manage Stress',
      description:
          'Practice stress-reduction techniques like meditation, deep breathing, or yoga. Chronic stress can negatively impact your health.',
      category: 'Mental Health',
    ),
    HealthTip(
      title: 'Wash Hands Frequently',
      description:
          'Proper handwashing with soap and water for at least 20 seconds helps prevent the spread of germs and infections.',
      category: 'Hygiene',
    ),
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredTips = _selectedCategory == 'All'
        ? _healthTips
        : _healthTips.where((tip) => tip.category == _selectedCategory).toList();

    final categories = [
      'All',
      ..._healthTips.map((tip) => tip.category).toSet().toList()
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Health Tips')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                return HealthTipCard(tip: tip);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HealthTip {
  final String title;
  final String description;
  final String category;

  HealthTip({
    required this.title,
    required this.description,
    required this.category,
  });
}

class HealthTipCard extends StatelessWidget {
  final HealthTip tip;

  const HealthTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(tip.description),
            const SizedBox(height: 8),
            Chip(
              label: Text(tip.category),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}
