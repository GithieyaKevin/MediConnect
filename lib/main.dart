import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Correct import
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/auth/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/patient/home_screen.dart';
import 'screens/health_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/patient/medication_reminder.dart';
import 'screens/patient/health_library.dart';
import 'screens/patient/health_tips.dart';
import 'screens/patient/emergency.dart';
import 'screens/patient/find_facilities.dart';
import 'screens/patient/health_records.dart';
import 'screens/doctor/patient_management.dart';
import 'screens/doctor/add_patient.dart';
import 'screens/doctor/add_vital_signs_screen.dart';
import 'screens/doctor/doctor_dashboard.dart';
import 'screens/patient/patient_dashboard.dart';
import 'models/app_user.dart' as app; // Ensure correct import with 'app' prefix

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: const MediConnectApp(),
    ),
  );
}

class MediConnectApp extends StatelessWidget {
  const MediConnectApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'MediConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<firebase_auth.User?>(
              stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final user = snapshot.data;
                if (user == null) {
                  return const LandingScreen();
                }

                return FutureBuilder<app.UserData?>(
                  future: Provider.of<DatabaseService>(context, listen: false)
                      .getUser(user.uid),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (userSnapshot.hasError || !userSnapshot.hasData) {
                      return const LandingScreen();
                    }
                    final userData = userSnapshot.data!;
                    return userData.isDoctor
                        ? const DoctorDashboard()
                        : const PatientDashboard();
                  },
                );
              },
            ),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/health': (context) => const HealthScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/medication_reminder': (context) => const MedicationReminderScreen(),
        '/health_library': (context) => const HealthLibraryScreen(),
        '/health_tips': (context) => const HealthTipsScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/find_facilities': (context) => const FindFacilitiesScreen(),
        '/health_records': (context) => const HealthRecordsScreen(),
        '/patient_management': (context) => const PatientManagementScreen(),
        '/add_patient': (context) => const AddPatientScreen(),
        '/add_vital_signs': (context) => const AddVitalSignsScreen(patientId: ''),
      },
    );
  }
}
