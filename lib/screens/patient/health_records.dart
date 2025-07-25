
// lib/screens/patient/health_records.dart
import 'package:flutter/material.dart';
import '../../models/vital_signs.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  late DatabaseService _databaseService;
  bool _isLoading = true;
  List<VitalSigns> _vitalSigns = [];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    _databaseService = DatabaseService();
    _loadVitalSigns(auth.currentUser?.uid ?? '');
  }

  Future<void> _loadVitalSigns(String patientId) async {
    setState(() => _isLoading = true);
    final vitalSigns = await _databaseService.getVitalSigns(patientId);
    setState(() {
      _vitalSigns = vitalSigns;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vitalSigns.isEmpty
              ? const Center(child: Text('No health records available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
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
    );
  }
}
