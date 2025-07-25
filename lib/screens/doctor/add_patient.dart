
// lib/screens/doctor/add_patient.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/patient.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _allergyController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _organDonorStatus;
  final List<String> _allergies = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addAllergy() {
    if (_allergyController.text.isNotEmpty) {
      setState(() {
        _allergies.add(_allergyController.text);
        _allergyController.clear();
      });
    }
  }

  void _removeAllergy(int index) {
    setState(() {
      _allergies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = DatabaseService(uid: authService.currentUser?.uid ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date of Birth'),
                    child: Text(
                      _selectedDate == null
                          ? 'Select date'
                          : DateFormat.yMMMMd().format(_selectedDate!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bloodTypeController,
                  decoration: const InputDecoration(labelText: 'Blood Type (e.g., A+)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter blood type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _organDonorStatus,
                  decoration: const InputDecoration(labelText: 'Organ Donor Status'),
                  items: ['Yes', 'No']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _organDonorStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Allergies', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _allergyController,
                        decoration: const InputDecoration(labelText: 'Add Allergy'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addAllergy,
                    ),
                  ],
                ),
                if (_allergies.isNotEmpty)
                  Column(
                    children: [
                      const Text('Current Allergies:'),
                      ..._allergies.asMap().entries.map((entry) {
                        final index = entry.key;
                        final allergy = entry.value;
                        return ListTile(
                          title: Text(allergy),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeAllergy(index),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedDate != null) {
                      final newPatient = Patient(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        email: _emailController.text,
                        dateOfBirth: _selectedDate!,
                        bloodType: _bloodTypeController.text,
                        gender: _selectedGender!,
                        allergies: _allergies,
                        organDonorStatus: _organDonorStatus,
                        primaryDoctorId: authService.currentUser?.uid ?? '',
                      );

                      await databaseService.addPatient(newPatient);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Patient'),
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
    _nameController.dispose();
    _emailController.dispose();
    _bloodTypeController.dispose();
    _allergyController.dispose();
    super.dispose();
  }
}
