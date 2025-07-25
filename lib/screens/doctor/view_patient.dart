
// lib/screens/doctor/view_patient.dart
import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../models/vital_signs.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewPatientScreen extends StatefulWidget {
  final Patient patient;

  const ViewPatientScreen({super.key, required this.patient});

  @override
  _ViewPatientScreenState createState() => _ViewPatientScreenState();
}

class _ViewPatientScreenState extends State<ViewPatientScreen> {
  late DatabaseService _databaseService;
  bool _isLoading = true;
  List<VitalSigns> _vitalSigns = [];

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _loadVitalSigns();
  }

  Future<void> _loadVitalSigns() async {
    setState(() => _isLoading = true);
    final vitalSigns = await _databaseService.getVitalSigns(widget.patient.id);
    setState(() {
      _vitalSigns = vitalSigns;
      _isLoading = false;
    });
  }

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name: ${widget.patient.name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Email: ${widget.patient.email}'),
        Text('Date of Birth: ${DateFormat.yMMMMd().format(widget.patient.dateOfBirth)}'),
        Text('Blood Type: ${widget.patient.bloodType.isNotEmpty ? widget.patient.bloodType : 'N/A'}'),
        Text('Gender: ${widget.patient.gender.isNotEmpty ? widget.patient.gender : 'N/A'}'),
        Text('Allergies: ${widget.patient.allergies.isNotEmpty ? widget.patient.allergies.join(', ') : 'None'}'),
        Text('Organ Donor: ${widget.patient.organDonorStatus ?? 'N/A'}'),
        Text('Primary Doctor ID: ${widget.patient.primaryDoctorId.isNotEmpty ? widget.patient.primaryDoctorId : 'N/A'}'),
      ],
    );
  }

  Widget _buildVitalSignsSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_vitalSigns.isEmpty) {
      return const Center(child: Text('No vital signs available'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vital Signs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _vitalSigns.length,
          itemBuilder: (context, index) {
            final vital = _vitalSigns[index];
            return Card(
              child: ListTile(
                title: Text('Recorded: ${DateFormat.yMMMMd().format(vital.dateTime)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Temperature: ${vital.temperature}°C'),
                    Text('Heart Rate: ${vital.heartRate} bpm'),
                    Text('Blood Pressure: ${vital.bloodPressure}'),
                    Text('Respiratory Rate: ${vital.respiratoryRate} breaths/min'),
                    Text('Oxygen Saturation: ${vital.oxygenSaturation}%'),
                    if (vital.notes != null) Text('Notes: ${vital.notes}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.patient.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfo(),
            const SizedBox(height: 24),
            _buildVitalSignsSection(),
          ],
        ),
      ),
    );
  }
}
