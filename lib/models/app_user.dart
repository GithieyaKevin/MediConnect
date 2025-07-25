
// lib/models/app_user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String name;
  final String email;
  final bool isDoctor;
  final String? specialty;
  final String? bloodType;
  final String? organDonorStatus;
  final List<String> allergies;
  final String? profileImageUrl;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.isDoctor,
    this.specialty,
    this.bloodType,
    this.organDonorStatus,
    this.allergies = const [],
    this.profileImageUrl,
  });

  factory UserData.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserData(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isDoctor: data['isDoctor'] ?? false,
      specialty: data['specialty'] as String?,
      bloodType: data['bloodType'] as String?,
      organDonorStatus: data['organDonorStatus'] as String?,
      allergies: List<String>.from(data['allergies'] ?? []),
      profileImageUrl: data['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'isDoctor': isDoctor,
      'specialty': specialty,
      'bloodType': bloodType,
      'organDonorStatus': organDonorStatus,
      'allergies': allergies,
      'profileImageUrl': profileImageUrl,
    };
  }
}
