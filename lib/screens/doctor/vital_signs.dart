import 'package:cloud_firestore/cloud_firestore.dart';

class VitalSigns {
  final String id;
  final String patientId;
  final DateTime dateTime;
  final double temperature;
  final int heartRate;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int respiratoryRate;
  final double oxygenSaturation;
  final String? notes;

  VitalSigns({
    required this.id,
    required this.patientId,
    required this.dateTime,
    required this.temperature,
    required this.heartRate,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.respiratoryRate,
    required this.oxygenSaturation,
    this.notes,
  });

  factory VitalSigns.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return VitalSigns(
      id: doc.id,
      patientId: data['patientId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      temperature: (data['temperature'] as num).toDouble(),
      heartRate: data['heartRate'] ?? 0,
      bloodPressureSystolic: data['bloodPressureSystolic'] ?? 0,
      bloodPressureDiastolic: data['bloodPressureDiastolic'] ?? 0,
      respiratoryRate: data['respiratoryRate'] ?? 0,
      oxygenSaturation: (data['oxygenSaturation'] as num).toDouble(),
      notes: data['notes'],
    );
  }

  String get bloodPressure => '$bloodPressureSystolic/$bloodPressureDiastolic mmHg';
}
