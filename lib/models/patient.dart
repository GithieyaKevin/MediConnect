
// lib/models/patient.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;
  final String name;
  final String email;
  final DateTime dateOfBirth;
  final String bloodType;
  final String gender;
  final List<String> allergies;
  final String? organDonorStatus;
  final String primaryDoctorId;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.bloodType,
    required this.gender,
    this.allergies = const [],
    this.organDonorStatus,
    required this.primaryDoctorId,
  });

  factory Patient.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Patient(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bloodType: data['bloodType'] ?? '',
      gender: data['gender'] ?? '',
      allergies: List<String>.from(data['allergies'] ?? []),
      organDonorStatus: data['organDonorStatus'] as String?,
      primaryDoctorId: data['primaryDoctorId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'bloodType': bloodType,
      'gender': gender,
      'allergies': allergies,
      'organDonorStatus': organDonorStatus,
      'primaryDoctorId': primaryDoctorId,
    };
  }

  int get age {
    final now = DateTime.now();
    return now.year - dateOfBirth.year -
        (now.month > dateOfBirth.month ||
                (now.month == dateOfBirth.month && now.day >= dateOfBirth.day)
            ? 0
            : 1);
  }
}
