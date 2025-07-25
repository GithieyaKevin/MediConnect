
// lib/screens/doctor/add_vital_signs_screen.dart
import 'package:flutter/material.dart';
import '../../models/vital_signs.dart';
import '../../services/database_service.dart';
import 'package:intl/intl.dart';

class AddVitalSignsScreen extends StatefulWidget {
  final String patientId;

  const AddVitalSignsScreen({super.key, required this.patientId});

  @override
  _AddVitalSignsScreenState createState() => _AddVitalSignsScreenState();
}

class _AddVitalSignsScreenState extends State<AddVitalSignsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _bpSystolicController = TextEditingController();
  final _bpDiastolicController = TextEditingController();
  final _respiratoryRateController = TextEditingController();
  final _oxygenSaturationController = TextEditingController();
  final _notesController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vital Signs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _temperatureController,
                  decoration: const InputDecoration(labelText: 'Temperature (°C)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter temperature';
                    }
                    final temp = double.tryParse(value);
                    if (temp == null || temp < 30 || temp > 45) {
                      return 'Please enter a valid temperature';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heartRateController,
                  decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter heart rate';
                    }
                    final hr = int.tryParse(value);
                    if (hr == null || hr < 30 || hr > 200) {
                      return 'Please enter a valid heart rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bpSystolicController,
                  decoration: const InputDecoration(labelText: 'Blood Pressure Systolic (mmHg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter systolic blood pressure';
                    }
                    final bp = int.tryParse(value);
                    if (bp == null || bp < 50 || bp > 250) {
                      return 'Please enter a valid systolic blood pressure';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bpDiastolicController,
                  decoration: const InputDecoration(labelText: 'Blood Pressure Diastolic (mmHg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter diastolic blood pressure';
                    }
                    final bp = int.tryParse(value);
                    if (bp == null || bp < 30 || bp > 150) {
                      return 'Please enter a valid diastolic blood pressure';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _respiratoryRateController,
                  decoration: const InputDecoration(labelText: 'Respiratory Rate (breaths/min)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter respiratory rate';
                    }
                    final rr = int.tryParse(value);
                    if (rr == null || rr < 5 || rr > 50) {
                      return 'Please enter a valid respiratory rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _oxygenSaturationController,
                  decoration: const InputDecoration(labelText: 'Oxygen Saturation (%)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter oxygen saturation';
                    }
                    final spo2 = double.tryParse(value);
                    if (spo2 == null || spo2 < 50 || spo2 > 100) {
                      return 'Please enter a valid oxygen saturation';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final vitalSigns = VitalSigns(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        patientId: widget.patientId,
                        dateTime: DateTime.now(),
                        temperature: double.parse(_temperatureController.text),
                        heartRate: int.parse(_heartRateController.text),
                        bloodPressureSystolic: int.parse(_bpSystolicController.text),
                        bloodPressureDiastolic: int.parse(_bpDiastolicController.text),
                        respiratoryRate: int.parse(_respiratoryRateController.text),
                        oxygenSaturation: double.parse(_oxygenSaturationController.text),
                        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                      );

                      await _databaseService.addVitalSigns(vitalSigns);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Vital Signs'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _heartRateController.dispose();
    _bpSystolicController.dispose();
    _bpDiastolicController.dispose();
    _respiratoryRateController.dispose();
    _oxygenSaturationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
