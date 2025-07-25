
// lib/screens/patient/patient_dashboard.dart
import 'package:flutter/material.dart';
import '../../widgets/chatbot.dart';
import '../../widgets/navigation_bar.dart';
import '../health_screen.dart';
import '../profile_screen.dart';
import '../settings_screen.dart';
import 'home_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HealthScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const ChatBotWidget(),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
