// lib/models/vital_signs.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class VitalSigns {
  final String id;
  final String patientId;
  final DateTime dateTime;
  final double temperature; // in Celsius
  final int heartRate; // bpm
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int respiratoryRate; // breaths per minute
  final double oxygenSaturation; // percentage
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
      patientId: data['patientId'] as String,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      temperature: (data['temperature'] as num).toDouble(),
      heartRate: data['heartRate'] as int,
      bloodPressureSystolic: data['bloodPressureSystolic'] as int,
      bloodPressureDiastolic: data['bloodPressureDiastolic'] as int,
      respiratoryRate: data['respiratoryRate'] as int,
      oxygenSaturation: (data['oxygenSaturation'] as num).toDouble(),
      notes: data['notes'] as String?,
    );
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map) {
    return VitalSigns(
      id: map['id'],
      patientId: map['patientId'],
      dateTime: DateTime.parse(map['dateTime']),
      temperature: map['temperature'].toDouble(),
      heartRate: map['heartRate'],
      bloodPressureSystolic: map['bloodPressureSystolic'],
      bloodPressureDiastolic: map['bloodPressureDiastolic'],
      respiratoryRate: map['respiratoryRate'],
      oxygenSaturation: map['oxygenSaturation'].toDouble(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
      'heartRate': heartRate,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'respiratoryRate': respiratoryRate,
      'oxygenSaturation': oxygenSaturation,
      'notes': notes,
    };
  }

  String get bloodPressure => '$bloodPressureSystolic/$bloodPressureDiastolic mmHg';
}
