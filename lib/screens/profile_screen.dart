import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/app_user.dart' as app;
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser; // Access the current user from AuthService

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user logged in')),
      );
    }

    final database = DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<app.UserData?>(
        stream: database.getUserStream(user.uid), // Use getUserStream from DatabaseService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading profile'));
          }

          final userData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userData.name}', style: const TextStyle(fontSize: 18)),
                Text('Email: ${userData.email}'),
                Text('Role: ${userData.isDoctor ? 'Doctor' : 'Patient'}'),
                if (userData.isDoctor)
                  Text('Specialty: ${userData.specialty ?? 'N/A'}'),
                if (!userData.isDoctor) ...[
                  Text('Blood Type: ${userData.bloodType ?? 'N/A'}'),
                  Text('Organ Donor: ${userData.organDonorStatus ?? 'N/A'}'),
                  Text('Allergies: ${userData.allergies.isEmpty ? 'None' : userData.allergies.join(', ')}'),
                ],
                if (userData.profileImageUrl != null)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userData.profileImageUrl!),
                        ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Example: Update profile or profile picture
                    try {
                      // Upload profile picture (example logic)
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child('profile_images/${user.uid}.jpg');
                      // Assuming you have an image picker logic here
                      // await storageRef.putFile(File('path/to/image'));
                      final downloadUrl = await storageRef.getDownloadURL();

                      await database.updateUserData(
                        name: userData.name,
                        email: userData.email,
                        isDoctor: userData.isDoctor,
                        specialty: userData.specialty,
                        bloodType: userData.bloodType,
                        organDonorStatus: userData.organDonorStatus,
                        allergies: userData.allergies,
                        profileImageUrl: downloadUrl,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
